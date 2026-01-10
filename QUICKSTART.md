# 🚀 QUICK START - Patient Contact Tracing System

## ⚡ TL;DR - Get Running in 5 Minutes

### Prerequisites Status:
- ✅ Python 3.11.9 - **Installed**
- ✅ Node.js 24.12.0 - **Installed**
- ⚠️ MongoDB - **NOT INSTALLED** (see below)
- ✅ Python dependencies - **Installed**
- ⚠️ Frontend dependencies - **Need to install**

---

## 🔴 CRITICAL: Install MongoDB First!

**Your system needs MongoDB to store data. Choose ONE option:**

### Option 1: Install MongoDB Locally (Recommended)

1. **Download MongoDB:**
   - Go to: https://www.mongodb.com/try/download/community
   - Download "MongoDB Community Server" for Windows
   - Version 7.0 or higher

2. **Install:**
   - Run the installer
   - Choose "Complete" installation
   - ✅ **IMPORTANT:** Check "Install MongoDB as a Service"
   - ✅ Also check "Install MongoDB Compass" (optional GUI)

3. **Verify Installation:**
   ```powershell
   # Run this command:
   Get-Service -Name MongoDB
   
   # Should show "Running" status
   ```

### Option 2: Use MongoDB Atlas (Cloud - Free)

1. Go to https://www.mongodb.com/cloud/atlas
2. Create free account
3. Create a free cluster (M0 tier)
4. Get connection string (click "Connect" → "Connect your application")
5. Update `.env` file:
   ```
   MONGODB_URI=mongodb+srv://yourusername:yourpassword@cluster.mongodb.net/
   ```

---

## 📦 Step 1: Install Frontend Dependencies

```powershell
cd C:\Projects\SIH25\SIH2K25\frontend
npm install
cd ..
```

This will take 1-2 minutes.

---

## 🚀 Step 2: Start the Application

### Method A: Use the provided batch files (Easiest)

**Terminal 1 - Backend:**
```powershell
# Double-click this file or run:
start_backend.bat
```

**Terminal 2 - Frontend:**
```powershell
# Double-click this file or run:
start_frontend.bat
```

### Method B: Manual commands

**Terminal 1 - Backend:**
```powershell
python start_server.py
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm run dev
```

---

## 🌐 Access the Application

1. **Wait for both servers to start** (about 10-20 seconds)

2. **Open your browser:**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:8000
   - API Docs: http://localhost:8000/docs

3. **Login:**
   - Username: `admin`
   - Password: `admin123`
   - ⚠️ Change password after first login!

---

## ✅ Verification Checklist

Run the requirements checker:
```powershell
check_requirements.bat
```

This will verify:
- ✅ Python installed
- ✅ Node.js installed
- ✅ MongoDB installed and running
- ✅ All dependencies installed
- ✅ Configuration files present

---

## 🔧 Common Issues & Quick Fixes

### Issue: "MongoDB connection failed"

**Fix:**
```powershell
# Start MongoDB service
net start MongoDB

# Or use the helper script:
mongodb_control.bat
```

### Issue: "Port 8000 already in use"

**Fix:**
```powershell
# Find what's using port 8000
netstat -ano | findstr :8000

# Kill that process (replace <PID> with the number shown)
taskkill /PID <PID> /F
```

### Issue: "Module not found" errors

**Fix:**
```powershell
# Reinstall Python dependencies
pip install -r requirements.txt

# Reinstall frontend dependencies
cd frontend
npm install
```

### Issue: Frontend can't connect to backend

**Check:**
1. Backend is running (Terminal 1 should show "Application startup complete")
2. No firewall blocking localhost:8000
3. Try clearing browser cache

---

## 📁 Project Structure

```
SIH2K25/
├── start_backend.bat          ← Start backend server
├── start_frontend.bat         ← Start frontend server
├── check_requirements.bat     ← Verify system setup
├── mongodb_control.bat        ← MongoDB service control
├── SETUP_GUIDE.md            ← Detailed setup guide
├── .env                       ← Configuration (created)
├── backend/                   ← FastAPI backend
│   ├── main.py               ← API entry point
│   └── routers/              ← API endpoints
├── frontend/                  ← React frontend
│   ├── src/                  ← Source code
│   └── package.json          ← Dependencies
└── src/                       ← AI/ML modules
    ├── vision.py             ← Face recognition
    ├── monitor_service.py    ← Contact monitoring
    └── yolov8n.pt           ← YOLO model
```

---

## 🎯 What to Do After Setup

1. **Login** to http://localhost:5173
2. **Change admin password** (User Management page)
3. **Register people:**
   - Go to "Register Person"
   - Fill in details
   - Capture 50 face samples with webcam
4. **Start monitoring:**
   - Go to "AI Monitoring"
   - Choose webcam or video file
   - Start contact detection
5. **View alerts** in the Alerts page

---

## 📊 System Features

- 👤 **Face Registration:** Register patients, doctors, staff with masks
- 🎥 **Live Monitoring:** Real-time contact detection via webcam
- 📹 **Video Analysis:** Upload and analyze recorded videos
- 🦠 **MDR Tracking:** Monitor multi-drug resistant patient contacts
- 📧 **Email Alerts:** Automatic notifications for MDR contacts
- 👥 **User Management:** Role-based access (Admin, EHR User, Officer)
- 📈 **Dashboard:** Real-time statistics and activity feed

---

## 🆘 Need Help?

1. **Check detailed guide:** See `SETUP_GUIDE.md`
2. **API Documentation:** http://localhost:8000/docs
3. **System logs:** Check terminal outputs
4. **Database GUI:** Use MongoDB Compass to view data

---

## 🔒 Security Notes

- Default admin password is `admin123` - **CHANGE IT!**
- JWT secret key in `.env` - change for production
- Don't commit `.env` file to version control
- Keep SMTP credentials secure

---

## 💡 Pro Tips

1. **GPU Acceleration:**
   - If you have NVIDIA GPU, set `FACE_REG_USE_GPU=true` in `.env`
   - Requires CUDA 12.1

2. **Better Performance:**
   - Close unnecessary browser tabs
   - Use Chrome/Edge for best performance
   - Ensure good lighting for webcam

3. **Testing:**
   - Use `test_cameras.py` to verify webcam setup
   - Check `http://localhost:8000/docs` for API testing

---

## 🎉 You're All Set!

The system is now ready to use. Enjoy the Patient Contact Tracing System!

**Quick Access:**
- 🌐 Web App: http://localhost:5173
- 📚 API Docs: http://localhost:8000/docs
- 💾 MongoDB: mongodb://localhost:27017

**Default Login:**
- Username: `admin`
- Password: `admin123`
