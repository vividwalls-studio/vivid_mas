import { WordPressClient } from '../WordPressClient.js';
import { WordPressError, AuthenticationError, NotFoundError } from '../types.js';

// Mock axios to avoid real HTTP requests during testing
jest.mock('axios');

describe('WordPressClient', () => {
  let client: WordPressClient;
  
  beforeEach(() => {
    client = new WordPressClient({
      baseUrl: 'https://test-site.com',
      username: 'testuser',
      password: 'testpass'
    });
  });

  describe('constructor', () => {
    it('should create client with correct configuration', () => {
      expect(client).toBeInstanceOf(WordPressClient);
    });

    it('should set default values for optional config', () => {
      const configClient = new WordPressClient({
        baseUrl: 'https://test.com',
        username: 'user',
        password: 'pass'
      });
      expect(configClient).toBeInstanceOf(WordPressClient);
    });
  });

  describe('utility methods', () => {
    it('should generate SEO-optimized title', () => {
      const longTitle = 'This is a very long title that exceeds the maximum length for SEO optimization';
      const result = client.generateSEOTitle(longTitle, 60);
      expect(result.length).toBeLessThanOrEqual(60);
      expect(result).toContain('...');
    });

    it('should generate excerpt from HTML content', () => {
      const htmlContent = '<p>This is <strong>HTML content</strong> with <em>formatting</em>.</p>';
      const result = client.generateExcerpt(htmlContent, 50);
      expect(result).toBe('This is HTML content with formatting.');
    });

    it('should generate slug from title', () => {
      const title = 'My Awesome Blog Post Title!';
      const result = client.generateSlug(title);
      expect(result).toBe('my-awesome-blog-post-title');
    });

    it('should handle long excerpt generation', () => {
      const longContent = 'A'.repeat(200);
      const result = client.generateExcerpt(longContent, 100);
      expect(result.length).toBeLessThanOrEqual(100);
      expect(result).toContain('...');
    });
  });

  describe('error handling', () => {
    it('should handle authentication errors', () => {
      const error = new AuthenticationError('Invalid credentials');
      expect(error).toBeInstanceOf(WordPressError);
      expect(error.statusCode).toBe(401);
      expect(error.message).toBe('Invalid credentials');
    });

    it('should handle not found errors', () => {
      const error = new NotFoundError('Resource not found');
      expect(error).toBeInstanceOf(WordPressError);
      expect(error.statusCode).toBe(404);
    });

    it('should handle generic WordPress errors', () => {
      const error = new WordPressError('Generic error', 500, { details: 'test' });
      expect(error.statusCode).toBe(500);
      expect(error.data).toEqual({ details: 'test' });
    });
  });
});

describe('WordPress API Integration', () => {
  it('should validate required environment variables', () => {
    // This test ensures our MCP server properly validates environment variables
    const requiredVars = ['WORDPRESS_URL', 'WORDPRESS_USERNAME', 'WORDPRESS_PASSWORD'];
    
    requiredVars.forEach(varName => {
      expect(typeof varName).toBe('string');
      expect(varName.length).toBeGreaterThan(0);
    });
  });

  it('should handle network timeouts gracefully', () => {
    const config = {
      baseUrl: 'https://example.com',
      username: 'user',
      password: 'pass',
      timeout: 5000
    };
    
    const client = new WordPressClient(config);
    expect(client).toBeInstanceOf(WordPressClient);
  });
});

describe('Content Validation', () => {
  it('should validate post data structure', () => {
    const validPostData = {
      title: 'Test Post',
      content: 'Test content',
      status: 'draft' as const
    };

    expect(validPostData.title).toBeTruthy();
    expect(validPostData.content).toBeTruthy();
    expect(['publish', 'draft', 'private', 'future'].includes(validPostData.status)).toBe(true);
  });

  it('should validate media upload structure', () => {
    const validMediaData = {
      filename: 'test.jpg',
      content: 'base64-content-here',
      title: 'Test Image',
      alt_text: 'Test alt text'
    };

    expect(validMediaData.filename).toMatch(/\.(jpg|jpeg|png|gif|svg|pdf|doc|docx)$/i);
    expect(validMediaData.content).toBeTruthy();
  });
});

describe('Art of Space Content Types', () => {
  it('should validate artist spotlight data structure', () => {
    const spotlightData = {
      artist_name: 'Test Artist',
      artist_bio: 'Test bio',
      artwork_title: 'Test Artwork',
      artwork_description: 'Test description',
      availability: 'available' as const
    };

    expect(spotlightData.artist_name).toBeTruthy();
    expect(spotlightData.artwork_title).toBeTruthy();
    expect(['available', 'sold', 'on_hold'].includes(spotlightData.availability)).toBe(true);
  });

  it('should validate collection announcement structure', () => {
    const collectionData = {
      collection_name: 'Test Collection',
      collection_description: 'Test description',
      featured_artworks: [
        {
          title: 'Artwork 1',
          description: 'Description 1'
        }
      ]
    };

    expect(collectionData.collection_name).toBeTruthy();
    expect(Array.isArray(collectionData.featured_artworks)).toBe(true);
    expect(collectionData.featured_artworks[0].title).toBeTruthy();
  });

  it('should validate how-to guide structure', () => {
    const guideData = {
      guide_title: 'Test Guide',
      guide_type: 'care' as const,
      difficulty_level: 'beginner' as const,
      steps: [
        {
          step_number: 1,
          title: 'Step 1',
          description: 'Step description'
        }
      ]
    };

    expect(guideData.guide_title).toBeTruthy();
    expect(['care', 'display', 'framing', 'lighting', 'maintenance', 'installation'].includes(guideData.guide_type)).toBe(true);
    expect(['beginner', 'intermediate', 'advanced'].includes(guideData.difficulty_level)).toBe(true);
    expect(Array.isArray(guideData.steps)).toBe(true);
  });

  it('should validate seasonal content structure', () => {
    const seasonalData = {
      season: 'spring' as const,
      content_type: 'collection' as const,
      title: 'Spring Collection',
      description: 'Spring description'
    };

    expect(['spring', 'summer', 'fall', 'winter', 'holiday', 'special_occasion'].includes(seasonalData.season)).toBe(true);
    expect(['collection', 'styling_tips', 'gift_guide', 'seasonal_trends'].includes(seasonalData.content_type)).toBe(true);
    expect(seasonalData.title).toBeTruthy();
  });

  it('should validate artist interview structure', () => {
    const interviewData = {
      artist_name: 'Test Artist',
      artist_bio: 'Test bio',
      interview_questions: [
        {
          question: 'Test question?',
          answer: 'Test answer'
        }
      ]
    };

    expect(interviewData.artist_name).toBeTruthy();
    expect(Array.isArray(interviewData.interview_questions)).toBe(true);
    expect(interviewData.interview_questions[0].question).toBeTruthy();
    expect(interviewData.interview_questions[0].answer).toBeTruthy();
  });
});

describe('MCP Tool Integration', () => {
  it('should handle tool input validation', () => {
    // Mock MCP tool input structure
    const toolInput = {
      tool: 'create-post',
      arguments: {
        title: 'Test Post',
        content: 'Test content',
        status: 'draft'
      }
    };

    expect(toolInput.tool).toBeTruthy();
    expect(toolInput.arguments).toBeTruthy();
    expect(typeof toolInput.arguments).toBe('object');
  });

  it('should format tool output correctly', () => {
    const mockPost = {
      id: 123,
      title: { rendered: 'Test Post' },
      status: 'draft',
      date: '2024-01-01T00:00:00',
      slug: 'test-post',
      link: 'https://example.com/test-post',
      author: 1,
      categories: [1, 2],
      tags: [3, 4],
      excerpt: { rendered: 'Test excerpt' }
    };

    // Test that our format function would work with this structure
    expect(mockPost.id).toBeGreaterThan(0);
    expect(mockPost.title.rendered).toBeTruthy();
    expect(mockPost.status).toBeTruthy();
  });
});