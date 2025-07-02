import { WordPressClient } from '../WordPressClient';
import axios from 'axios';

// Mock axios to avoid real HTTP requests during testing
jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;

describe('WordPressClient', () => {
  let client: WordPressClient;
  
  beforeEach(() => {
    // Reset mocks
    jest.clearAllMocks();
    
    // Mock axios.create to return a mocked instance
    mockedAxios.create = jest.fn(() => ({
      get: jest.fn(),
      post: jest.fn(),
      put: jest.fn(),
      delete: jest.fn(),
      patch: jest.fn(),
      request: jest.fn(),
      defaults: {
        headers: {
          common: {}
        }
      }
    } as any));
    
    mockedAxios.isAxiosError = jest.fn((payload): payload is any => true) as any;
    
    client = new WordPressClient('https://test-site.com', 'testuser', 'testpass');
  });

  describe('constructor', () => {
    it('should create client with correct configuration', () => {
      expect(client).toBeInstanceOf(WordPressClient);
      expect(mockedAxios.create).toHaveBeenCalledWith({
        baseURL: 'https://test-site.com/wp-json',
        auth: {
          username: 'testuser',
          password: 'testpass'
        },
        headers: {
          'Content-Type': 'application/json'
        },
        timeout: 30000
      });
    });

    it('should handle URLs with trailing slash', () => {
      const configClient = new WordPressClient('https://test.com/', 'user', 'pass');
      expect(configClient).toBeInstanceOf(WordPressClient);
      expect(mockedAxios.create).toHaveBeenCalledWith(
        expect.objectContaining({
          baseURL: 'https://test.com/wp-json'
        })
      );
    });
  });

  describe('discoverEndpoints', () => {
    it('should discover endpoints successfully', async () => {
      const mockResponse = {
        data: {
          routes: {
            '/wp/v2/posts': {
              namespace: 'wp/v2',
              methods: ['GET', 'POST'],
              endpoints: [{ methods: ['GET'] }, { methods: ['POST'] }]
            },
            '/wp/v2/pages': {
              namespace: 'wp/v2',
              methods: ['GET', 'POST'],
              endpoints: [{ methods: ['GET'] }, { methods: ['POST'] }]
            }
          }
        }
      };

      const axiosInstance = mockedAxios.create();
      (axiosInstance.get as jest.Mock).mockResolvedValue(mockResponse);

      const endpoints = await client.discoverEndpoints();
      
      expect(endpoints).toHaveProperty('/wp/v2/posts');
      expect(endpoints).toHaveProperty('/wp/v2/pages');
      expect(endpoints['/wp/v2/posts'].namespace).toBe('wp/v2');
    });

    it('should handle discovery errors', async () => {
      const axiosInstance = mockedAxios.create();
      (axiosInstance.get as jest.Mock).mockRejectedValue(new Error('Network error'));
      mockedAxios.isAxiosError.mockReturnValue(true);

      await expect(client.discoverEndpoints()).rejects.toThrow('Failed to discover endpoints');
    });
  });

  describe('callEndpoint', () => {
    it('should make GET request successfully', async () => {
      const mockResponse = {
        data: [{ id: 1, title: { rendered: 'Test Post' } }],
        status: 200,
        headers: {
          'x-wp-total': '10',
          'x-wp-totalpages': '2'
        }
      };

      const axiosInstance = mockedAxios.create();
      (axiosInstance.request as jest.Mock).mockResolvedValue(mockResponse);

      const result = await client.callEndpoint('/wp/v2/posts', 'GET', { per_page: 5 });
      
      expect(result.data).toEqual(mockResponse.data);
      expect(result.status).toBe(200);
      expect(result.pagination).toEqual({
        total: 10,
        totalPages: 2
      });
    });

    it('should make POST request successfully', async () => {
      const postData = { title: 'New Post', content: 'Content' };
      const mockResponse = {
        data: { id: 123, ...postData },
        status: 201,
        headers: {}
      };

      const axiosInstance = mockedAxios.create();
      (axiosInstance.request as jest.Mock).mockResolvedValue(mockResponse);

      const result = await client.callEndpoint('/wp/v2/posts', 'POST', undefined, postData);
      
      expect(axiosInstance.request).toHaveBeenCalledWith({
        method: 'POST',
        url: '/wp/v2/posts',
        data: postData
      });
      expect(result.data.id).toBe(123);
    });

    it('should handle API errors', async () => {
      const axiosInstance = mockedAxios.create();
      const errorResponse = {
        response: {
          status: 404,
          data: { message: 'Post not found' }
        }
      };
      
      (axiosInstance.request as jest.Mock).mockRejectedValue(errorResponse);
      mockedAxios.isAxiosError.mockReturnValue(true);

      await expect(client.callEndpoint('/wp/v2/posts/999', 'GET'))
        .rejects.toThrow('WordPress API error (404)');
    });
  });

  describe('testConnection', () => {
    it('should return true for successful connection', async () => {
      const axiosInstance = mockedAxios.create();
      (axiosInstance.get as jest.Mock).mockResolvedValue({ data: {} });

      const result = await client.testConnection();
      expect(result).toBe(true);
    });

    it('should return false for failed connection', async () => {
      const axiosInstance = mockedAxios.create();
      (axiosInstance.get as jest.Mock).mockRejectedValue(new Error('Connection failed'));

      const result = await client.testConnection();
      expect(result).toBe(false);
    });
  });
});
