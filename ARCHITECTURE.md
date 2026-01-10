# 🔄 SYSTEM FLOW & ARCHITECTURE

## 📊 Application Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USER INTERACTION                             │
│                  (Web Browser: localhost:5173)                       │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ HTTP Requests
                             ↓
┌─────────────────────────────────────────────────────────────────────┐
│                    FRONTEND (React + Vite)                           │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                │
│  │  Login Page  │ │  Dashboard   │ │ Register     │                │
│  │              │ │              │ │ Person       │                │
│  └──────────────┘ └──────────────┘ └──────────────┘                │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                │
│  │   Alerts     │ │ AI Monitoring│ │     MDR      │                │
│  │              │ │              │ │ Management   │                │
│  └──────────────┘ └──────────────┘ └──────────────┘                │
│                                                                       │
│  Port: 5173                                                          │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ API Calls (/api/*)
                             │ WebSocket (for live monitoring)
                             ↓
┌─────────────────────────────────────────────────────────────────────┐
│                    BACKEND (FastAPI)                                 │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      ROUTERS                                 │   │
│  ├─────────────────────────────────────────────────────────────┤   │
│  │ /api/auth         → Login, JWT tokens                       │   │
│  │ /api/persons      → Person CRUD operations                  │   │
│  │ /api/face         → Face registration, webcam capture       │   │
│  │ /api/mdr          → MDR patient management                  │   │
│  │ /api/alerts       → Alert management                        │   │
│  │ /api/monitoring   → AI video/webcam processing              │   │
│  │ /api/dashboard    → Statistics and metrics                  │   │
│  │ /api/unknown      → Unknown person tracking                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                             │                                        │
│  Port: 8000                 │                                        │
└─────────────────────────────┼────────────────────────────────────────┘
                              │
                              │ Database Queries
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                    DATABASE (MongoDB)                                │
│                                                                       │
│  Collections:                                                        │
│  • users               → System users & authentication              │
│  • persons             → Registered people (patients, staff)        │
│  • face_embeddings     → Face recognition data                      │
│  • mdr_patients        → MDR patient records                        │
│  • pathogens           → Pathogen definitions                       │
│  • alerts              → Contact alert records                      │
│  • contacts            → Person contact events                      │
│  • unknown_persons     → Unidentified people                        │
│  • monitoring_sessions → AI monitoring session data                 │
│                                                                       │
│  Port: 27017 (local) or mongodb+srv:// (Atlas)                      │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              │ Data Processing
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                  AI/ML COMPONENTS (src/)                             │
│                                                                       │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │  Face Detection  │  │  Person Tracking │  │   Re-ID/OSNet   │  │
│  │  (InsightFace)   │  │  (YOLO v8)       │  │   (DeepSORT)    │  │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │ Mask Detection   │  │ Distance Calc    │  │ Collision Detect│  │
│  │  (Classifier)    │  │  (Calibration)   │  │  (IoU/Distance) │  │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

## 🔄 Request Flow Examples

### Example 1: User Login
```
1. User enters username/password in browser
   ↓
2. Frontend sends POST /api/auth/login
   ↓
3. Backend validates credentials against MongoDB
   ↓
4. Backend creates JWT token
   ↓
5. Frontend stores token in localStorage
   ↓
6. All future requests include token in Authorization header
```

### Example 2: Face Registration
```
1. User fills person details (name, role, ID)
   ↓
2. User clicks "Start Capture" 
   ↓
3. Frontend opens webcam via React Webcam
   ↓
4. For each of 50 samples:
   - Frontend captures frame
   - Sends base64 image to POST /api/face/capture
   - Backend uses InsightFace to detect face
   - Backend extracts embeddings (512-dim vector)
   - Backend stores in MongoDB
   ↓
5. Person registered with 50 face samples
```

### Example 3: Live Monitoring
```
1. User selects "Live Webcam" mode
   ↓
2. User chooses camera indices (0, 1)
   ↓
3. Frontend sends POST /api/monitoring/start
   ↓
4. Backend starts background monitoring task:
   - Opens webcam streams
   - YOLO detects persons in each frame
   - DeepSORT tracks each person across frames
   - Calculates distances between persons
   - Matches faces to registered persons
   - Detects collisions (close contacts)
   ↓
5. Backend sends frames via WebSocket
   ↓
6. Frontend displays live frames with annotations
   ↓
7. When collision detected:
   - Backend stores alert in MongoDB
   - Backend broadcasts alert via WebSocket
   - Frontend shows notification
   - (Optional) Backend sends email if MDR patient
```

## 🗂️ File Structure & Responsibilities

### Backend Files
```
backend/
├── main.py                      # FastAPI app initialization
├── routers/
│   ├── auth.py                  # Login, JWT, user management
│   ├── persons.py               # CRUD for registered persons
│   ├── face_registration.py     # Webcam capture, face processing
│   ├── mdr.py                   # MDR patient management
│   ├── pathogens.py             # Pathogen definitions
│   ├── alerts.py                # Alert queries
│   ├── dashboard.py             # Statistics aggregation
│   ├── monitoring.py            # AI monitoring (video/webcam)
│   └── unknown_persons.py       # Unknown person tracking
```

### Frontend Files
```
frontend/src/
├── main.jsx                     # App entry point
├── App.jsx                      # Router configuration
├── pages/
│   ├── Login.jsx                # Login page
│   ├── Dashboard.jsx            # Main dashboard
│   ├── RegisterPerson.jsx       # Face registration
│   ├── RegisteredPersons.jsx    # Person list/CRUD
│   ├── MDRManagement.jsx        # MDR management
│   ├── Alerts.jsx               # Alert list
│   ├── Monitoring.jsx           # AI monitoring interface
│   └── UserManagement.jsx       # User CRUD (admin)
├── components/
│   ├── Layout.jsx               # Page layout wrapper
│   └── (other reusable components)
├── api/
│   └── index.js                 # API client (axios)
└── context/
    └── AuthContext.jsx          # Auth state management
```

### AI/ML Files
```
src/
├── vision.py                    # InsightFace wrapper
├── face_db_mongo.py             # Face database operations
├── reid_tracker.py              # Person tracking (YOLO + DeepSORT)
├── collision_detector.py        # Collision detection
├── distance_utils.py            # Distance calculations
├── monitor_service.py           # Main monitoring orchestration
├── alert_system_mongo.py        # Alert generation
├── email_alerter_mongo.py       # Email notifications
├── mdr_tracker_mongo.py         # MDR patient tracking
├── unknown_tracker_mongo.py     # Unknown person tracking
├── database.py                  # MongoDB connection
└── config.py                    # Environment config loader
```

## 🎯 Data Flow for Contact Detection

```
┌─────────────────┐
│ Camera Frames   │
└────────┬────────┘
         │
         ↓
┌─────────────────────────┐
│ YOLO Person Detection   │  ← Detects all persons in frame
│ (person_detector.py)    │     Returns bounding boxes
└────────┬────────────────┘
         │
         ↓
┌─────────────────────────┐
│ DeepSORT Tracking       │  ← Assigns consistent IDs
│ (reid_tracker.py)       │     Tracks persons across frames
└────────┬────────────────┘
         │
         ↓
┌─────────────────────────┐
│ Face Recognition        │  ← Matches faces to known persons
│ (vision.py)             │     Using face embeddings
└────────┬────────────────┘
         │
         ↓
┌─────────────────────────┐
│ Distance Calculation    │  ← Calculates physical distance
│ (distance_utils.py)     │     Between detected persons
└────────┬────────────────┘
         │
         ↓
┌─────────────────────────┐
│ Collision Detection     │  ← Detects when persons too close
│ (collision_detector.py) │     Based on IoU or distance
└────────┬────────────────┘
         │
         ↓
┌─────────────────────────┐
│ Alert Generation        │  ← Creates alert if collision
│ (alert_system_mongo.py) │     Stores in MongoDB
└────────┬────────────────┘
         │
         ↓
┌─────────────────────────┐
│ Email Notification      │  ← Sends email if MDR patient
│ (email_alerter_mongo.py)│     involved in contact
└─────────────────────────┘
```

## 🔐 Authentication Flow

```
User Login
    ↓
POST /api/auth/login
    ↓
Backend checks MongoDB users collection
    ↓
If valid → Create JWT token
    │
    ├─ Token contains: user_id, username, role
    ├─ Signed with JWT_SECRET_KEY
    └─ Expires after JWT_ACCESS_TOKEN_EXPIRE_MINUTES
    ↓
Frontend stores token in localStorage
    ↓
All requests include: Authorization: Bearer <token>
    ↓
Backend validates token on each request
    ↓
If valid → Allow request
If invalid/expired → Return 401
```

## 🗄️ Database Schema

### users Collection
```javascript
{
  _id: ObjectId,
  username: String,          // Unique username
  email: String,             // User email
  password_hash: String,     // Bcrypt hashed password
  role: String,              // "admin", "ehr_user", "officer"
  full_name: String,         // Display name
  created_at: DateTime,
  updated_at: DateTime
}
```

### persons Collection
```javascript
{
  _id: ObjectId,
  person_id: String,         // P001, D001, V001, etc.
  name: String,              // Full name
  role: String,              // "patient", "doctor", "nurse", "visitor", "worker"
  gender: String,            // "male", "female", "other"
  age: Number,
  contact: String,           // Phone number
  address: String,
  emergency_contact: String,
  medical_history: String,
  notes: String,
  created_at: DateTime,
  updated_at: DateTime
}
```

### face_embeddings Collection
```javascript
{
  _id: ObjectId,
  person_id: String,         // Links to persons.person_id
  embedding: Array<Float>,   // 512-dimensional face vector
  has_mask: Boolean,         // Was wearing mask in sample
  confidence: Float,         // Detection confidence
  created_at: DateTime
}
```

### mdr_patients Collection
```javascript
{
  _id: ObjectId,
  person_id: String,         // Links to persons.person_id
  pathogen_ids: Array<ObjectId>, // Links to pathogens
  marked_at: DateTime,
  marked_by: String,         // Username who marked
  notes: String
}
```

### alerts Collection
```javascript
{
  _id: ObjectId,
  person1_id: String,        // First person involved
  person1_name: String,
  person2_id: String,        // Second person involved
  person2_name: String,
  contact_duration: Number,  // Seconds
  risk_score: Float,         // 0.0 - 1.0
  timestamp: DateTime,
  camera: String,            // "front", "side", "both"
  snapshot: String,          // Base64 or file path
  alert_type: String,        // "mdr_contact", "collision"
  acknowledged: Boolean
}
```

## 🎨 Frontend State Management

```
AuthContext (React Context)
    ↓
Provides to all components:
    - user (current user object)
    - token (JWT token)
    - login(username, password)
    - logout()
    - isAuthenticated

Each Page Component:
    ↓
Uses AuthContext for auth state
    ↓
Uses axios (api/index.js) for API calls
    ↓
Axios interceptor adds token to headers
    ↓
On 401 response → Auto logout & redirect to login
```

## ⚡ Performance Optimizations

1. **Face Recognition:**
   - Embeddings pre-computed during registration
   - Stored in MongoDB for fast lookup
   - GPU acceleration optional (CUDA)

2. **Person Tracking:**
   - DeepSORT maintains track history
   - Re-ID features reduce identity switches
   - Box shrinking improves track stability

3. **Database:**
   - Indexes on person_id, username
   - Aggregation pipelines for stats
   - Connection pooling

4. **Frontend:**
   - Vite for fast dev server & HMR
   - React lazy loading for code splitting
   - Tailwind CSS for optimized styles

## 🔄 Monitoring Session Lifecycle

```
1. START REQUEST
   POST /api/monitoring/start
       ↓
2. VALIDATE INPUT
   Check mode, camera indices/video paths
       ↓
3. CREATE SESSION
   Generate session_id
   Set status = "starting"
       ↓
4. START BACKGROUND TASK
   asyncio.create_task(monitoring_loop)
       ↓
5. MONITORING LOOP
   While not stopped:
       - Read frames from cameras/videos
       - Detect persons
       - Track persons
       - Recognize faces
       - Calculate distances
       - Detect collisions
       - Generate alerts
       - Broadcast frames via WebSocket
       ↓
6. STOP REQUEST
   POST /api/monitoring/stop
       ↓
7. CLEANUP
   Stop task
   Release cameras
   Set status = "idle"
```

This architecture ensures:
- ✅ Scalability (async processing)
- ✅ Real-time updates (WebSocket)
- ✅ Separation of concerns (routers, services, AI)
- ✅ Security (JWT auth)
- ✅ Maintainability (clear structure)
