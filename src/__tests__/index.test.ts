import { APP_NAME, greet } from '../index';

describe('index', () => {
  describe('APP_NAME', () => {
    it('should be defined', () => {
      expect(APP_NAME).toBe('Kiro Project Template');
    });
  });

  describe('greet', () => {
    it('should return a greeting with the provided name', () => {
      const result = greet('Developer');
      expect(result).toBe('Hello, Developer! Welcome to Kiro Project Template.');
    });

    it('should handle empty string', () => {
      const result = greet('');
      expect(result).toBe('Hello, ! Welcome to Kiro Project Template.');
    });
  });
});
