import axios, { AxiosInstance } from 'axios';
import FormData from 'form-data';

const POSTIZ_API_URL = 'https://postiz.vividwalls.blog/api/public/v1';

export interface PostFilters {
  display?: 'day' | 'week' | 'month';
  day?: number; // 0-6
  week?: number; // 1-52
  month?: number; // 1-12
  year?: number; // 2022+
}

export interface MediaDto {
  id: string;
  path: string;
}

export interface PostContent {
  content: string;
  id?: string;
  image?: MediaDto[];
}

export interface Integration {
  id: string;
}

export interface Tag {
  value: string;
  label: string;
}

export interface SinglePost {
  integration: Integration;
  value: PostContent[];
  group?: string;
  settings?: any;
}

export interface CreatePostData {
  type: 'draft' | 'schedule' | 'now';
  date: string;
  order?: string;
  shortLink?: boolean;
  inter?: number;
  tags?: Tag[];
  posts: SinglePost[];
}

export class PostizApiClient {
  private client: AxiosInstance;

  constructor(apiKey: string) {
    this.client = axios.create({
      baseURL: POSTIZ_API_URL,
      headers: {
        Authorization: apiKey,
        'Content-Type': 'application/json',
      },
    });
  }

  /**
   * Get all integrations
   * @returns {Promise<any>}
   */
  async getIntegrations(): Promise<any> {
    try {
      const response = await this.client.get('/integrations');
      return response.data;
    } catch (error) {
      console.error('Error fetching integrations:', error);
      throw error;
    }
  }

  /**
   * Get posts from Postiz with optional filters
   * @param {PostFilters} filters - Optional filters for posts
   * @returns {Promise<any>}
   */
  async getPosts(filters?: PostFilters): Promise<any> {
    try {
      const response = await this.client.get('/posts', { params: filters });
      return response.data;
    } catch (error) {
      console.error('Error fetching posts:', error);
      throw error;
    }
  }

  /**
   * Create or update posts in Postiz
   * @param {CreatePostData} postData - The data for creating posts
   * @returns {Promise<any>}
   */
  async createPost(postData: CreatePostData): Promise<any> {
    try {
      const response = await this.client.post('/posts', postData);
      return response.data;
    } catch (error) {
      console.error('Error creating post:', error);
      throw error;
    }
  }

  /**
   * Delete a post by ID
   * @param {string} postId - The ID of the post to delete
   * @returns {Promise<any>}
   */
  async deletePost(postId: string): Promise<any> {
    try {
      const response = await this.client.delete(`/posts/${postId}`);
      return response.data;
    } catch (error) {
      console.error('Error deleting post:', error);
      throw error;
    }
  }

  /**
   * Upload a file
   * @param {Buffer} fileBuffer - The file buffer
   * @param {string} fileName - The file name
   * @param {string} mimeType - The file mime type
   * @returns {Promise<any>}
   */
  async uploadFile(fileBuffer: Buffer, fileName: string, mimeType: string): Promise<any> {
    try {
      const formData = new FormData();
      formData.append('file', fileBuffer, { filename: fileName, contentType: mimeType });
      
      const response = await this.client.post('/upload', formData, {
        headers: {
          ...formData.getHeaders(),
          Authorization: this.client.defaults.headers.common['Authorization'],
        },
      });
      return response.data;
    } catch (error) {
      console.error('Error uploading file:', error);
      throw error;
    }
  }
} 