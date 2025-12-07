# Environment Variables Setup Guide

## 📋 Quick Setup

### Step 1: Get Your Pexels API Key

1. Visit [https://www.pexels.com/api/](https://www.pexels.com/api/)
2. Sign up for a free account (or log in if you already have one)
3. Navigate to your API dashboard
4. Copy your API key

### Step 2: Create .env File

1. Copy the example file:
   ```bash
   cp .env.example .env
   ```

2. Open `.env` file in your editor

3. Replace `your_pexels_api_key_here` with your actual API key:
   ```
   PEXELS_API_KEY=your_actual_api_key_here
   ```

### Step 3: Verify Setup

The `.env` file is automatically loaded when the app starts (in `bootstrap.dart`).

To verify it's working:
1. Run the app: `flutter run`
2. Check the console - you should NOT see the warning about missing .env file
3. Test Pexels API functionality in your app

---

## 🔒 Security Notes

- ✅ `.env` is already added to `.gitignore` - it will NOT be committed to version control
- ✅ `.env.example` is committed as a template for other developers
- ⚠️ **Never commit your actual `.env` file with real API keys**

---

## 🛠️ Troubleshooting

### Issue: "Could not load .env file" warning

**Solution:**
- Make sure `.env` file exists in the project root (same level as `pubspec.yaml`)
- Check that the file name is exactly `.env` (not `.env.txt` or similar)
- Verify the file format is correct (no extra spaces, one key per line)

### Issue: "Pexels API key not configured" error

**Solution:**
- Verify your `.env` file contains: `PEXELS_API_KEY=your_key_here`
- Make sure there are no quotes around the API key value
- Check that there are no extra spaces before/after the `=` sign
- Restart the app after modifying `.env`

### Issue: API calls failing with 401 Unauthorized

**Solution:**
- Verify your API key is correct
- Check that you haven't exceeded the rate limit (200 requests/hour for free tier)
- Make sure the API key is active in your Pexels dashboard

---

## 📝 File Structure

```
ev_charging_user_app/
├── .env                    # Your actual API keys (NOT committed)
├── .env.example            # Template file (committed)
├── lib/
│   ├── bootstrap.dart      # Loads .env file here
│   └── core/
│       └── constants/
│           └── env.dart    # Accesses env variables
└── pubspec.yaml            # Includes flutter_dotenv dependency
```

---

## 🔄 For Team Members

When cloning the repository:

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Add your own Pexels API key to `.env`

3. The `.env` file will be ignored by git, so each developer uses their own key

---

## 📚 Additional Resources

- [Pexels API Documentation](https://www.pexels.com/api/documentation/)
- [flutter_dotenv Package](https://pub.dev/packages/flutter_dotenv)
- [Pexels API Dashboard](https://www.pexels.com/api/)

---

**Setup completed!** Your app is now configured to use Pexels API with environment variables. 🎉

