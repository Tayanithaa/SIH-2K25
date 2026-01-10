# Patient Contact Tracing System - Setup Guide

## System Overview
This is a comprehensive Patient Contact Tracing System for hospitals, built for SIH 2025. It includes:
- Face recognition with mask support
- Real-time person tracking and collision detection
- MDR (Multi-Drug Resistant) patient monitoring
- Web-based dashboard with role-based access
- AI-powered video/webcam monitoring

---

## Prerequisites Checklist

Before running the application, ensure you have:

- ✅ **Python 3.10 or higher** installed
- ✅ **Node.js 18 or higher** installed
- ✅ **MongoDB** installed and running (Community Edition is fine)
- ✅ **Webcam** (for face registration and live monitoring)
- ✅ **GPU with CUDA 12.1** (optional, for better performance)

---

## Step 1: MongoDB Setup

### Option A: Install MongoDB Locally (Recommended for Laptops)

1. **Download MongoDB Community Edition:**
   - Visit: https://www.mongodb.com/try/download/community
   - Download version 7.0 or higher for Windows
   - Run the installer and choose "Complete" installation
   - ✅ Check "Install MongoDB as a Service" during installation
   - ✅ Check "Install MongoDB Compass" (GUI tool)

2. **Verify MongoDB is running:**
   ```powershell
   # Open PowerShell and run:
   mongod --version
   
   # Check if MongoDB service is running:
   Get-Service -Name MongoDB
   ```

3. **If MongoDB is not running as a service:**
   ```powershell
   # Start MongoDB manually:
   net start MongoDB
   ```

### Option B: Use MongoDB Atlas (Cloud - Free Tier Available)

1. Create free account at https://www.mongodb.com/cloud/atlas
2. Create a free cluster
3. Get connection string (looks like: `mongodb+srv://username:password@cluster.mongodb.net/`)
4. Update `.env` file with your connection string:
   ```
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/
   ```

---

## Step 2: Python Environment Setup

1. **Ensure you're in the project directory:**
   ```powershell
   cd C:\Projects\SIH25\SIH2K25
   ```

2. **Install Python dependencies:**
   ```powershell
   # The dependencies are already installed from your previous command
   # If you need to reinstall:
   pip install -r requirements.txt
   ```

3. **Verify YOLO model file exists:**
   - The file `src/yolov8n.pt` should already exist
   - If missing, it will be auto-downloaded on first run

---

## Step 3: Frontend Setup

1. **Navigate to frontend directory:**
   ```powershell
   cd frontend
   ```

2. **Install Node.js dependencies:**
   ```powershell
   npm install
   ```

3. **Return to project root:**
   ```powershell
   cd ..
   ```

---

## Step 4: Configuration Check

1. **Review the `.env` file** (already created in project root)
   - MongoDB connection is set to: `mongodb://localhost:27017`
   - Default admin credentials will be created automatically
   - Email alerts are optional (update SMTP settings if needed)

2. **Optional: Configure Email Alerts**
   If you want MDR patient contact email alerts:
   - Update these values in `.env`:
     ```
     MDR_SMTP_USERNAME=your-email@gmail.com
     MDR_SMTP_PASSWORD=your-app-password
     MDR_ADMIN_EMAIL=admin@hospital.com
     ```
   - For Gmail, create an "App Password": https://myaccount.google.com/apppasswords

---

## Step 5: Running the Application

### Terminal 1: Start Backend Server

```powershell
# In project root directory:
python start_server.py
```

**Expected output:**
- Server starting on http://localhost:8000
- Database connection successful
- Default admin user created (username: admin, password: admin123)

**Backend URLs:**
- API Server: http://localhost:8000
- API Documentation: http://localhost:8000/docs
- Interactive API: http://localhost:8000/redoc

### Terminal 2: Start Frontend Development Server

```powershell
# In project root, open a NEW terminal:
cd frontend
npm run dev
```

**Expected output:**
- Frontend running on http://localhost:5173

**Access the web app:**
- Open browser: http://localhost:5173
- Login with: username=`admin`, password=`admin123`
- ⚠️ Change admin password after first login!

---

## Step 6: Using the System

### 1. Login
- Use default credentials: admin / admin123
- Change password in User Management after first login

### 2. Register People
- Go to "Register Person" page
- Fill in person details (name, role, ID)
- Capture 50 face samples using webcam
- System works with or without masks

### 3. Monitor Contacts
- Go to "AI Monitoring" page
- Choose Video File or Live Webcam mode
- Start monitoring to detect close contacts
- View alerts in real-time

### 4. MDR Management
- Go to "MDR Management" page
- Mark patients as MDR
- System will alert when MDR patients have close contacts

---

## Troubleshooting

### Issue: MongoDB Connection Failed

**Solution:**
```powershell
# Check if MongoDB is running:
Get-Service -Name MongoDB

# If stopped, start it:
net start MongoDB

# Or restart it:
net stop MongoDB
net start MongoDB
```

### Issue: Port 8000 Already in Use

**Solution:**
```powershell
# Find and kill process using port 8000:
netstat -ano | findstr :8000
# Note the PID (last column)
taskkill /PID <PID> /F
```

### Issue: Frontend Can't Connect to Backend

**Check:**
- Backend is running on http://localhost:8000
- Check browser console for errors
- Verify CORS settings in backend/main.py

### Issue: Webcam Not Working

**Check:**
- Camera permissions in Windows Settings
- Camera is not being used by another app
- Try different camera index (0, 1, 2) in settings

### Issue: Face Recognition Not Working

**Check:**
- Good lighting conditions
- Face clearly visible to camera
- Minimum confidence threshold in .env (default: 0.35)
- YOLO model file exists in src/yolov8n.pt

---

## Quick Reference Commands

```powershell
# Start backend
python start_server.py

# Start frontend (in new terminal)
cd frontend
npm run dev

# Check MongoDB status
Get-Service -Name MongoDB

# Start MongoDB
net start MongoDB

# View backend logs
# (check terminal where start_server.py is running)

# Access API docs
# Open browser: http://localhost:8000/docs
```

---

## Default Login Credentials

- **Username:** admin
- **Password:** admin123
- **⚠️ IMPORTANT:** Change password after first login!

---

## System Architecture

```
┌─────────────────────────────────────────────────┐
│         Frontend (React + Vite)                  │
│         http://localhost:5173                    │
└────────────────┬────────────────────────────────┘
                 │ API Requests
                 ↓
┌─────────────────────────────────────────────────┐
│         Backend (FastAPI)                        │
│         http://localhost:8000                    │
└────────────────┬────────────────────────────────┘
                 │ Database Queries
                 ↓
┌─────────────────────────────────────────────────┐
│         MongoDB (Database)                       │
│         mongodb://localhost:27017                │
└─────────────────────────────────────────────────┘
```

---

## Next Steps After Setup

1. ✅ Login to web interface
2. ✅ Change default admin password
3. ✅ Create additional users (EHR User, Officer roles)
4. ✅ Register people (patients, doctors, staff)
5. ✅ Mark MDR patients if needed
6. ✅ Start monitoring using AI Monitoring page

---

## Support & Documentation

- **API Documentation:** http://localhost:8000/docs
- **Project README:** See README.md in project root
- **Configuration:** See .env file for all settings

---

## Security Notes

- Change JWT_SECRET_KEY in .env before production use
- Change default admin password immediately
- Keep SMTP credentials secure
- Use environment variables for sensitive data
- Enable HTTPS in production

---

## Performance Tips

1. **GPU Acceleration:**
   - Set `FACE_REG_USE_GPU=true` in .env if you have NVIDIA GPU
   - Requires CUDA 12.1 and compatible PyTorch installation

2. **MongoDB Performance:**
   - Keep database on SSD for better performance
   - Regularly monitor database size

3. **Camera Performance:**
   - Use lower resolution for faster processing
   - Reduce frame rate if system is slow

---

## Enjoy using the Patient Contact Tracing System! 🎉
