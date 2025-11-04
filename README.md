
# WALKIE-TALKIE APP - TECHNICAL PROJECT DOCUMENTATION

## Project Overview

The Walkie-Talkie app is a real-time voice communication platform built with Flutter, enabling instant Push-to-Talk (PTT) conversations through three distinct modes: Duo (one-on-one), Group (multiple participants), and Public (random global channels). The app leverages WebRTC for peer-to-peer audio streaming, Auth0 for secure authentication, and Socket.io for real-time signaling.

## Project Goals

- Deliver ultra-low latency voice communication (<200ms)
- Provide seamless authentication via Auth0 Google Sign-In
- Enable reliable background audio with persistent notifications
- Support both Android and iOS platforms with native features
- Ensure scalable architecture for growing user base
- Implement robust error handling and reconnection logic

## Key Features

- **Secure Authentication**: Auth0 integration with Google Sign-In, JWT-based session management
- **Three Communication Modes**: 
  - Duo: Private one-on-one PTT conversations
  - Group: Multi-participant voice channels
  - Public: Random global channel discovery
- **Real-Time Audio**: WebRTC peer-to-peer audio streaming with automatic quality adaptation
- **Push-to-Talk Interface**: Hold-to-speak button with visual audio feedback
- **Audio Visualizer**: Animated "glyph matrix" reflecting voice activity
- **Background Audio**: Continue conversations with app in background
- **Push Notifications**: FCM (Android) and APNs (iOS) for incoming calls
- **Homescreen Widget**: Quick access to PTT functionality (Android)
- **Offline Detection**: Smart reconnection and network status handling

## Design Philosophy

- **DM Serif Text** font for consistent typography
- Color palette: Black (#1E1E1E, #171717), Off-white (#FFEBEB), Red (#FF0000, #E81F1F), White-gray (#D9D9D9), White (#FFFFFF)
- Minimalist, intuitive UI focusing on core PTT functionality
- Responsive animations for audio feedback
- Accessible design following WCAG guidelines
      `
    },
    {
      id: 'techstack',
      title: '2. Technology Stack & Services Map',
      content: `
## Technology Stack

### Frontend
- **Framework**: Flutter 3.x (latest stable)
- **State Management**: flutter_riverpod 2.x
- **UI Components**: Material Design 3 with custom theming
- **Audio Handling**: flutter_webrtc for WebRTC integration
- **Real-time Communication**: socket_io_client for signaling
- **Authentication**: auth0_flutter SDK
- **Notifications**: firebase_messaging, flutter_local_notifications
- **Storage**: flutter_secure_storage for tokens
- **Permissions**: permission_handler
- **Background Service**: flutter_background_service
- **Typography**: google_fonts (DM Serif Text)

### Backend
- **Runtime**: Node.js 18+ LTS
- **Framework**: Express.js 4.x
- **Real-time**: Socket.io 4.x
- **Database ORM**: Sequelize or Prisma
- **Authentication**: Auth0 Management API
- **Push Notifications**: Firebase Admin SDK, node-apn
- **Environment Management**: dotenv
- **Logging**: Winston or Pino
- **API Documentation**: Swagger/OpenAPI

### Database
- **Primary Database**: PostgreSQL 15+
- **Schema Management**: Migrations via Sequelize/Prisma
- **Connection Pooling**: pg-pool
- **Backup Strategy**: Automated daily backups

### Authentication & Authorization
- **Provider**: Auth0
- **Social Login**: Google Sign-In (OAuth 2.0)
- **Token Type**: JWT (JSON Web Tokens)
- **Token Storage**: Flutter Secure Storage
- **Session Management**: Refresh token rotation

### Real-Time Communication
- **Media Streaming**: WebRTC (STUN/TURN)
- **Signaling**: Socket.io over WebSockets
- **TURN Server**: Twilio TURN, Xirsys, or coturn (self-hosted)
- **Media Server**: Optional: Janus WebRTC Server for scaling

### Push Notifications
- **Android**: Firebase Cloud Messaging (FCM)
- **iOS**: Apple Push Notification service (APNs) via FCM
- **Backend Integration**: Firebase Admin SDK

## Services Responsibility Map

| Service/Technology | Responsibility | Integration Points |
|-------------------|----------------|-------------------|
| **Auth0** | User authentication, OAuth flow, JWT issuance | Flutter app (login), Backend (token validation) |
| **Google Sign-In** | Third-party identity provider | Auth0 (connection), User profile sync |
| **Flutter WebRTC** | Capture/stream audio, handle media tracks | Socket.io (signaling), TURN server |
| **Socket.io Client** | Send/receive signaling messages | Backend Socket.io server, WebRTC negotiation |
| **Socket.io Server** | Room management, message routing | All connected clients, Database (session logs) |
| **PostgreSQL** | Store users, channels, sessions, logs | Backend APIs, Auth0 (user metadata sync) |
| **FCM** | Deliver push notifications | Backend (send), Flutter app (receive/display) |
| **APNs** | iOS push notifications | FCM (gateway), Backend (payload creation) |
| **TURN Server** | NAT traversal, relay audio packets | WebRTC (ICE candidates), Backend (credential generation) |
| **Riverpod** | App state management | All Flutter screens/widgets |
| **Express REST API** | User management, channel CRUD | Flutter HTTP client, Database |

## Architecture Layers

1. **Presentation Layer** (Flutter)
   - UI components and screens
   - User interaction handling
   - Audio visualizer
   - State management (Riverpod)

2. **Business Logic Layer** (Flutter Services)
   - Authentication service (Auth0 wrapper)
   - WebRTC service (peer connection management)
   - Socket service (signaling logic)
   - Notification service (FCM handling)

3. **Communication Layer**
   - REST API calls (HTTP)
   - WebSocket connections (Socket.io)
   - WebRTC peer connections

4. **Backend Layer** (Node.js/Express)
   - REST API endpoints
   - Socket.io event handlers
   - Auth0 token validation
   - Database operations
   - FCM/APNs integration

5. **Data Layer** (PostgreSQL)
   - User profiles
   - Channel/group data
   - Session history
   - Device tokens
      `
    },
    {
      id: 'architecture',
      title: '3. High-Level Architecture',
      content: `
## System Architecture Diagram

```mermaid
graph TB
    subgraph "Client Apps"
        A1[Flutter App - User A]
        A2[Flutter App - User B]
    end
    
    subgraph "Authentication"
        AUTH[Auth0]
        GOOGLE[Google OAuth]
    end
    
    subgraph "Backend Services"
        API[Express REST API]
        SOCKET[Socket.io Server]
        FCM_SERV[FCM Service]
    end
    
    subgraph "Database"
        DB[(PostgreSQL)]
    end
    
    subgraph "External Services"
        TURN[TURN Server]
        FCM[Firebase FCM]
        APNS[Apple APNs]
    end
    
    A1 -->|Login| AUTH
    A2 -->|Login| AUTH
    AUTH -->|OAuth| GOOGLE
    AUTH -->|JWT| A1
    AUTH -->|JWT| A2
    
    A1 -->|REST API| API
    A2 -->|REST API| API
    API -->|Query/Update| DB
    
    A1 <-->|Signaling| SOCKET
    A2 <-->|Signaling| SOCKET
    SOCKET -->|Session Data| DB
    
    A1 <-->|Audio Stream| TURN
    A2 <-->|Audio Stream| TURN
    A1 -.->|P2P Audio| A2
    
    API -->|Send Notification| FCM_SERV
    FCM_SERV -->|Android| FCM
    FCM_SERV -->|iOS| APNS
    FCM -->|Push| A1
    APNS -->|Push| A2
```

**Architecture Explanation:**

1. **Client Layer**: Flutter apps communicate via multiple channels - HTTP for API calls, WebSocket for signaling, and WebRTC for media streaming.

2. **Authentication Flow**: Auth0 manages authentication with Google as identity provider. JWT tokens secure all subsequent communications.

3. **Signaling Server**: Socket.io handles WebRTC signaling (offer/answer/ICE candidates) and room management.

4. **Media Flow**: WebRTC establishes peer-to-peer audio streams. TURN server relays traffic when direct connection fails.

5. **Push Notifications**: Backend sends notifications via FCM (for Android) and APNs (for iOS) when users receive incoming calls while app is backgrounded.

6. **Data Persistence**: PostgreSQL stores user profiles, channel metadata, and session logs.

## Component Interaction Flow

```mermaid
sequenceDiagram
    participant User
    participant Flutter
    participant Auth0
    participant Backend
    participant Socket.io
    participant Database
    
    User->>Flutter: Open App
    Flutter->>Auth0: Check Auth Status
    alt Not Authenticated
        Auth0-->>Flutter: No Valid Token
        User->>Flutter: Tap Sign In
        Flutter->>Auth0: Initiate Google Sign-In
        Auth0->>User: Google OAuth Consent
        User->>Auth0: Approve
        Auth0-->>Flutter: JWT Access Token
        Flutter->>Backend: Register Device Token
        Backend->>Database: Store User & Token
    else Authenticated
        Auth0-->>Flutter: Valid Token
    end
    
    Flutter->>Backend: Fetch User Data
    Backend->>Database: Query User
    Database-->>Backend: User Data
    Backend-->>Flutter: User Profile
    Flutter->>Socket.io: Connect with JWT
    Socket.io->>Backend: Validate Token
    Backend-->>Socket.io: Token Valid
    Socket.io-->>Flutter: Connected
    Flutter->>User: Show Dashboard
```

## Data Flow Architecture

**Authentication Data Flow:**
1. User initiates login → Auth0 redirects to Google
2. Google returns authorization code → Auth0 exchanges for tokens
3. Auth0 issues JWT → Flutter stores securely
4. Backend validates JWT for all requests

**Voice Communication Data Flow:**
1. User A presses PTT → Flutter requests microphone permission
2. Socket.io signal: "start-call" → Backend routes to User B
3. WebRTC negotiation (offer/answer/ICE) via Socket.io
4. Direct audio stream (User A ↔ User B) via WebRTC
5. If NAT blocks: TURN server relays audio packets
6. User A releases PTT → "end-call" signal → streams closed

**Notification Data Flow:**
1. User A starts call, User B offline → Backend detects
2. Backend queries DB for User B's FCM token
3. FCM/APNs payload created → sent to Firebase
4. Firebase delivers to User B's device
5. User B taps notification → App opens, auto-joins call
      `
    },
    {
      id: 'auth',
      title: '4. Authentication Implementation (Auth0 + Google)',
      content: `
## Auth0 Setup & Configuration

### Auth0 Dashboard Setup

**Step 1: Create Auth0 Account**
- Visit https://auth0.com and sign up (free tier available)
- Create a new tenant (e.g., "walkie-talkie-prod")
- Note down: Domain (e.g., your-tenant.us.auth0.com) and Client ID

**Step 2: Configure Google Social Connection**
1. Navigate to **Authentication > Social**
2. Enable **Google** connection
3. Obtain Google OAuth credentials:
   - Go to Google Cloud Console (console.cloud.google.com)
   - Create new project: "Walkie-Talkie"
   - Enable Google+ API
   - Create OAuth 2.0 credentials (OAuth client ID)
   - Select "Web application"
   - Add authorized redirect URIs:
     - https://YOUR_AUTH0_DOMAIN/login/callback
   - Copy Client ID and Client Secret
4. Paste Google credentials into Auth0 Google connection
5. Set permissions: email, profile, openid
6. Enable "Sync user profile attributes" at each login

**Step 3: Create Auth0 Application**
1. Go to **Applications > Applications**
2. Click **Create Application**
3. Name: "Walkie-Talkie Mobile"
4. Type: **Native**
5. Click **Create**

**Step 4: Configure Application Settings**
- **Allowed Callback URLs**: 
  - com.yourcompany.walkietalkie://login-callback
  - com.yourcompany.walkietalkie.auth0://callback
- **Allowed Logout URLs**:
  - com.yourcompany.walkietalkie://logout
- **Allowed Web Origins**:
  - (leave empty for mobile)
- **Grant Types**: Enable
  - Authorization Code
  - Refresh Token
  - Implicit (for mobile)

**Step 5: Configure JWT Settings**
1. Go to **Applications > APIs > Auth0 Management API**
2. Note the API Identifier (e.g., https://YOUR_DOMAIN/api/v2/)
3. Token Expiration: 86400 seconds (24 hours)
4. Refresh Token Rotation: **Enabled**
5. Refresh Token Expiration: 30 days

**Step 6: Create API for Backend**
1. **Applications > APIs > Create API**
2. Name: "Walkie-Talkie API"
3. Identifier: https://api.walkietalkie.com
4. Signing Algorithm: RS256
5. Enable RBAC: Yes (optional, for future roles)

### Environment Variables (Auth0)

Create `.env` file in your backend:

```
AUTH0_DOMAIN=your-tenant.us.auth0.com
AUTH0_CLIENT_ID=your_client_id_here
AUTH0_CLIENT_SECRET=your_client_secret_here
AUTH0_AUDIENCE=https://api.walkietalkie.com
AUTH0_ISSUER=https://your-tenant.us.auth0.com/
```

For Flutter app, store in environment config:

```
AUTH0_DOMAIN=your-tenant.us.auth0.com
AUTH0_CLIENT_ID=your_mobile_client_id
AUTH0_REDIRECT_URI=com.yourcompany.walkietalkie://login-callback
```

## Flutter Auth0 Integration

### Required Packages

Add to `pubspec.yaml`:
```
dependencies:
  auth0_flutter: ^1.4.0
  flutter_secure_storage: ^9.0.0
  flutter_riverpod: ^2.4.0
```

### Auth0 Configuration Steps

**Android Setup (`android/app/build.gradle`):**
- Add manifest placeholders:
  ```
  android {
    defaultConfig {
      manifestPlaceholders = [auth0Domain: "YOUR_DOMAIN", auth0Scheme: "YOUR_SCHEME"]
    }
  }
  ```

**iOS Setup (`ios/Runner/Info.plist`):**
- Add URL scheme:
  ```xml
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>None</string>
      <key>CFBundleURLName</key>
      <string>auth0</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>com.yourcompany.walkietalkie</string>
      </array>
    </dict>
  </array>
  ```

### Authentication Service Architecture

**Riverpod Provider Structure:**

1. **Auth Repository Provider**: Manages Auth0 SDK instance
2. **Auth State Provider**: Tracks current authentication state
3. **User Profile Provider**: Stores user information
4. **Token Provider**: Manages JWT access and refresh tokens

**Key Methods to Implement:**

- `login()`: Initiate Auth0 Universal Login with Google
- `logout()`: Clear tokens and revoke refresh token
- `getAccessToken()`: Retrieve current valid JWT
- `refreshToken()`: Obtain new access token
- `isAuthenticated()`: Check if user has valid session

## Authentication Flow Diagrams

### First-Time User Sign-Up Flow

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Auth0
    participant Google
    participant Backend
    participant DB
    
    User->>App: Tap "Sign in with Google"
    App->>Auth0: Initiate login (webAuth.login)
    Auth0->>Google: Redirect to Google OAuth
    Google->>User: Show consent screen
    User->>Google: Grant permission
    Google->>Auth0: Authorization code
    Auth0->>Auth0: Exchange code for tokens
    Auth0->>Auth0: Create user profile
    Auth0-->>App: Return JWT + Refresh Token
    App->>App: Store tokens securely
    
    App->>Backend: POST /api/users/register
    Note over App,Backend: Headers: Authorization: Bearer {JWT}
    Backend->>Auth0: Validate JWT
    Auth0-->>Backend: Token valid, user info
    Backend->>DB: INSERT user profile
    Backend->>DB: Store FCM device token
    Backend-->>App: User created successfully
    
    App->>Backend: WebSocket connect (JWT)
    Backend->>Backend: Authenticate socket
    Backend-->>App: Socket connected
    App->>User: Navigate to Dashboard
```

### Returning User Login Flow

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Auth0
    participant Backend
    
    User->>App: Open app
    App->>App: Check stored tokens
    
    alt Token exists and valid
        App->>Backend: Request user data (with JWT)
        Backend->>Auth0: Validate token
        Auth0-->>Backend: Valid
        Backend-->>App: User data
        App->>User: Show dashboard
    else Token expired
        App->>Auth0: Refresh token request
        Auth0-->>App: New access token
        App->>App: Update stored token
        App->>Backend: Request user data
        Backend-->>App: User data
        App->>User: Show dashboard
    else No token
        App->>User: Show login screen
        User->>App: Tap login
        Note over App,Auth0: Follow first-time flow
    end
```

## Token Management Strategy

**Access Token:**
- Lifetime: 24 hours
- Stored in: FlutterSecureStorage
- Used for: All API requests
- Refresh when: 1 hour before expiry or on 401 error

**Refresh Token:**
- Lifetime: 30 days
- Stored in: FlutterSecureStorage
- Used for: Obtaining new access tokens
- Rotation: Enabled (new refresh token with each refresh)

**Token Validation (Backend):**
1. Extract JWT from Authorization header
2. Verify signature using Auth0 JWKS endpoint
3. Check expiration (exp claim)
4. Validate issuer (iss) and audience (aud)
5. Extract user ID from sub claim

## Common Auth0 Pitfalls & Solutions

**Issue 1: Redirect URI Mismatch**
- **Symptom**: "callback URL mismatch" error
- **Solution**: Ensure exact match between app scheme and Auth0 dashboard callback URLs. Check for trailing slashes.

**Issue 2: Token Expiry Not Handled**
- **Symptom**: 401 errors after some time
- **Solution**: Implement token refresh interceptor. Use riverpod to automatically refresh before expiry.

**Issue 3: Google Connection Not Working**
- **Symptom**: Login button shows but nothing happens
- **Solution**: Verify Google Cloud Console has correct OAuth redirect URIs and Auth0 Google connection is enabled.

**Issue 4: iOS Universal Links Not Working**
- **Symptom**: Callback doesn't return to app
- **Solution**: Configure Associated Domains capability in Xcode. Verify apple-app-site-association file.

**Issue 5: Token Storage Insecure**
- **Symptom**: Security audit flags
- **Solution**: Always use FlutterSecureStorage, never SharedPreferences for tokens.

## Security Considerations

1. **Never log tokens**: Ensure no JWT tokens appear in logs
2. **Rotate refresh tokens**: Enable rotation in Auth0 settings
3. **Implement logout**: Clear all tokens and revoke on backend
4. **HTTPS only**: All Auth0 communication over HTTPS
5. **Validate on backend**: Never trust client-provided tokens without validation
6. **Rate limiting**: Limit authentication attempts to prevent brute force
7. **Biometric lock**: Optional: Add biometric authentication before showing app content
      `
    },
    {
      id: 'webrtc',
      title: '5. WebRTC + Socket.io Real-Time Communication',
      content: `
## WebRTC Architecture Overview

WebRTC (Web Real-Time Communication) enables peer-to-peer audio streaming with minimal latency. Socket.io handles the signaling phase where peers exchange connection information before establishing direct media connections.

### WebRTC Components

1. **PeerConnection**: Manages the connection between two peers
2. **MediaStream**: Represents audio data from microphone
3. **DataChannel**: Optional: for sending text metadata
4. **ICE (Interactive Connectivity Establishment)**: NAT traversal mechanism
5. **STUN Server**: Discovers public IP addresses
6. **TURN Server**: Relays media when direct connection fails

### Socket.io Role

Socket.io serves as the signaling server, facilitating:
- Peer discovery (who's in the channel)
- Session negotiation (offer/answer exchange)
- ICE candidate exchange
- Room/channel management
- Presence notifications (user joined/left)

## Flutter WebRTC Setup

### Required Packages

```
dependencies:
  flutter_webrtc: ^0.9.48
  socket_io_client: ^2.0.3
  permission_handler: ^11.0.1
  flutter_riverpod: ^2.4.0
```

### Platform Permissions

**Android (`android/app/src/main/AndroidManifest.xml`):**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
```

**iOS (`ios/Runner/Info.plist`):**
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access required for voice communication</string>
<key>NSCameraUsageDescription</key>
<string>Camera access may be required for future video calls</string>
```

### WebRTC Configuration

**ICE Servers Configuration:**

Free STUN servers (for development):
```
{
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},
    {'urls': 'stun:stun1.l.google.com:19302'},
  ]
}
```

TURN server configuration (production):
```
{
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},
    {
      'urls': 'turn:your-turn-server.com:3478',
      'username': 'user',
      'credential': 'pass'
    }
  ]
}
```

**Recommended TURN Providers:**
1. **Twilio TURN** (easiest, pay-as-you-go)
   - Dashboard: console.twilio.com
   - Good for production
   - Pricing: ~$0.40/GB

2. **Xirsys** (developer-friendly)
   - Dashboard: xirsys.com
   - Free tier available
   - Global edge locations

3. **Self-hosted coturn** (cost-effective at scale)
   - Open source TURN server
   - Requires VPS/cloud instance
   - Full control, but needs maintenance

**Default Recommendation**: Start with Twilio TURN for simplicity

## Socket.io Backend Setup

### Server Configuration

**Install Dependencies:**
```bash
npm install express socket.io cors dotenv
npm install --save-dev @types/socket.io
```

**Environment Variables:**
```
SOCKET_PORT=3001
SOCKET_CORS_ORIGIN=*
AUTH0_DOMAIN=your-tenant.auth0.com
TURN_SERVER_URL=turn:your-server.com:3478
TURN_USERNAME=user
TURN_CREDENTIAL=pass
```

### Socket.io Server Structure

**Server Initialization:**
1. Create Express app
2. Attach Socket.io to HTTP server
3. Enable CORS for Flutter clients
4. Implement JWT middleware for socket authentication
5. Create namespaces for different channel types

**Key Socket Events to Implement:**

**Client → Server:**
- `join-channel`: User joins a voice channel
- `leave-channel`: User leaves channel
- `offer`: WebRTC offer from initiator
- `answer`: WebRTC answer from receiver
- `ice-candidate`: ICE candidate exchange
- `start-speaking`: User presses PTT
- `stop-speaking`: User releases PTT

**Server → Client:**
- `user-joined`: New user entered channel
- `user-left`: User disconnected
- `offer`: Forward offer to peer
- `answer`: Forward answer to peer
- `ice-candidate`: Forward ICE candidate
- `speaking-started`: Someone began speaking
- `speaking-stopped`: Someone stopped speaking
- `channel-full`: Channel at capacity

### Room Management Logic

**Room Structure:**
```
{
  channelId: string,
  users: [{
    socketId: string,
    userId: string,
    isSpeaking: boolean,
    joinedAt: timestamp
  }],
  maxUsers: number,
  type: 'duo' | 'group' | 'public'
}
```

**Join Channel Flow:**
1. Client emits `join-channel` with {channelId, userId, JWT}
2. Server validates JWT
3. Check if channel exists, create if needed
4. Check capacity (duo: 2, group: configurable, public: unlimited)
5. Add user to room
6. Notify existing users of new participant
7. Return channel info and existing participants

**Leave Channel Flow:**
1. Client emits `leave-channel` or disconnects
2. Server removes user from room
3. Notify remaining users
4. If room empty, optionally delete room record
5. Log session end in database

## WebRTC Signaling Flow

### Peer-to-Peer Connection Establishment

```mermaid
sequenceDiagram
    participant A as User A (Caller)
    participant SA as Socket.io Server
    participant B as User B (Receiver)
    
    A->>SA: join-channel {channelId}
    SA->>SA: Create/join room
    B->>SA: join-channel {channelId}
    SA->>A: user-joined {userId: B}
    SA->>B: user-joined {userId: A}
    
    Note over A: User A presses PTT
    A->>A: Create RTCPeerConnection
    A->>A: Get microphone stream
    A->>A: Add audio track to connection
    A->>A: Create offer
    A->>SA: offer {sdp, channelId, targetUserId: B}
    SA->>B: offer {sdp, fromUserId: A}
    
    Note over B: Receive offer
    B->>B: Create RTCPeerConnection
    B->>B: Set remote description (offer)
    B->>B: Create answer
    B->>SA: answer {sdp, channelId, targetUserId: A}
    SA->>A: answer {sdp, fromUserId: B}
    
    Note over A: Receive answer
    A->>A: Set remote description (answer)
    
    Note over A,B: ICE Candidate Exchange
    A->>SA: ice-candidate {candidate, channelId, targetUserId: B}
    SA->>B: ice-candidate {candidate, fromUserId: A}
    B->>SA: ice-candidate {candidate, channelId, targetUserId: A}
    SA->>A: ice-candidate {candidate, fromUserId: B}
    
    Note over A,B: Connection Established
    A->>B: Direct audio stream (RTP)
    B->>A: Acknowledgment
```

### PTT Lifecycle (Push-to-Talk)

```mermaid
sequenceDiagram
    participant User
    participant App
    participant WebRTC
    participant Socket
    participant Peer
    
    User->>App: Press PTT button
    App->>App: Request microphone permission
    alt Permission granted
        App->>WebRTC: getUserMedia({audio: true})
        WebRTC-->>App: MediaStream
        App->>Socket: emit('start-speaking', {channelId, userId})
        Socket-->>Peer: speaking-started {userId}
        
        loop Audio streaming
            App->>WebRTC: Add audio track
            WebRTC->>WebRTC: Encode audio (Opus codec)
            WebRTC->>Peer: Send RTP packets
        end
        
        User->>App: Release PTT button
        App->>WebRTC: Stop media tracks
        App->>Socket: emit('stop-speaking', {channelId, userId})
        Socket-->>Peer: speaking-stopped {userId}
        Peer->>Peer: Stop playback
    else Permission denied
        App->>User: Show permission request dialog
    end
```

## Flutter WebRTC Service Implementation

### Service Structure

**WebRTC Service Responsibilities:**
1. Initialize RTCPeerConnection
2. Manage local media stream (microphone)
3. Handle offer/answer negotiation
4. Process ICE candidates
5. Monitor connection state
6. Handle disconnections and reconnections

**Socket Service Responsibilities:**
1. Establish WebSocket connection
2. Authenticate with JWT
3. Emit and listen to signaling events
4. Maintain room state
5. Handle reconnection logic

### Riverpod Provider Architecture

**Core Providers:**

1. `socketServiceProvider`: Manages Socket.io connection
2. `webrtcServiceProvider`: Manages WebRTC peer connections
3. `channelStateProvider`: Current channel information
4. `activeSpeakerProvider`: Who's currently speaking
5. `connectionStatusProvider`: Network and connection state

### Key Implementation Steps

**Step 1: Initialize Socket.io Connection**
- Connect to backend WebSocket endpoint
- Authenticate with JWT in connection options
- Set up event listeners for signaling events
- Implement automatic reconnection

**Step 2: Request Microphone Permission**
- Use permission_handler package
- Request RECORD_AUDIO permission
- Handle permission denial gracefully
- Show permission rationale dialog

**Step 3: Create Peer Connection**
- Initialize RTCPeerConnection with ICE server config
- Set up event listeners (onIceCandidate, onTrack, onConnectionStateChange)
- Configure audio constraints (echoCancellation, noiseSuppression, autoGainControl)

**Step 4: Capture Audio Stream**
- Call navigator.mediaDevices.getUserMedia
- Specify audio constraints (sampleRate: 48000, channelCount: 1)
- Add audio track to peer connection

**Step 5: Create and Send Offer**
- Generate SDP offer via createOffer()
- Set local description
- Emit offer via Socket.io to target peer

**Step 6: Receive and Process Answer**
- Listen for answer event from Socket.io
- Set remote description with received SDP

**Step 7: Handle ICE Candidates**
- Listen for onIceCandidate events
- Send candidates via Socket.io
- Add received candidates via addIceCandidate()

**Step 8: Monitor Connection State**
- Track RTCPeerConnectionState (connected, disconnected, failed)
- Implement reconnection logic on failure
- Update UI based on connection status

## Group Call Architecture

For group calls (>2 participants), implement **Selective Forwarding Unit (SFU)** pattern:

**Mesh vs SFU:**
- **Mesh**: Each peer connects to every other peer (N² connections). Not scalable.
- **SFU**: Each peer sends one stream to server, receives multiple streams. Server forwards to others. Scalable.

**Recommended for Groups:**
- Use **Janus WebRTC Server** or **Mediasoup** as SFU
- Configure backend to route streams through SFU
- Client still uses WebRTC, but connects to SFU instead of peers

**Small Groups (<5 users):**
- Mesh topology acceptable for simplicity
- Each Flutter client manages multiple RTCPeerConnections

## WebRTC Codec Configuration

**Audio Codec Priority:**
1. **Opus** (preferred): Best for voice, handles packet loss well
2. **G.722**: Fallback for compatibility
3. **PCMU/PCMA**: Legacy codecs

**Configure codec in SDP:**
- Modify SDP offer to prioritize Opus
- Set opus parameters: maxaveragebitrate=510000, stereo=0, useinbandfec=1

**Audio Constraints:**
```
{
  audio: {
    echoCancellation: true,
    noiseSuppression: true,
    autoGainControl: true,
    sampleRate: 48000,
    channelCount: 1
  }
}
```

## Common WebRTC Issues & Solutions

**Issue 1: No Audio Transmission**
- **Check**: Microphone permission granted
- **Check**: Audio track added to peer connection
- **Check**: ICE candidates successfully exchanged
- **Debug**: Log onTrack event, verify remote stream exists

**Issue 2: One-Way Audio**
- **Cause**: Firewall blocking incoming UDP
- **Solution**: Ensure TURN server configured correctly
- **Test**: Use Twilio's network test tool

**Issue 3: High Latency**
- **Cause**: TURN relay instead of direct P2P
- **Solution**: Verify STUN server accessible, check NAT type
- **Optimize**: Reduce audio bitrate, disable bandwidth probing

**Issue 4: Connection Drops**
- **Cause**: Network instability, signaling server down
- **Solution**: Implement ICE restart, fallback signaling paths
- **Monitor**: Track connection state, auto-reconnect on failure

**Issue 5: Echo/Feedback**
- **Cause**: Audio output feeding back into microphone
- **Solution**: Enable echoCancellation in audio constraints
- **Test**: Use headphones, verify AEC working

## Performance Optimization

1. **Lazy Load Peer Connections**: Don't create until needed
2. **Close Unused Connections**: Dispose when user leaves channel
3. **Implement Connection Pooling**: Reuse connections for same peer
4. **Monitor Stats**: Use getStats() API to track packet loss, jitter, RTT
5. **Adaptive Bitrate**: Adjust based on network conditions
6. **Background Handling**: Pause streams when app backgrounded (except during active call)

## Testing WebRTC

**Unit Tests:**
- Mock Socket.io events
- Test peer connection state transitions
- Verify offer/answer generation

**Integration Tests:**
- Connect two devices on same network
- Verify audio transmitted and received
- Test ICE candidate exchange

**Network Condition Tests:**
- Use Android/iOS network throttling
- Simulate poor network (high latency, packet loss)
- Verify TURN fallback works

**Load Tests:**
- Multiple concurrent channels
- Group calls with max participants
- Measure CPU/memory usage
      `
    },
    {
      id: 'notifications',
      title: '6. Push Notifications (FCM + APNs)',
      content: `
## Push Notification Architecture

Push notifications alert users to incoming calls when the app is in the background or terminated. Firebase Cloud Messaging (FCM) handles delivery for both Android and iOS (via APNs integration).

### FCM + APNs Integration Flow

```mermaid
graph LR
    A[Backend Server] -->|Send Notification| B[Firebase FCM]
    B -->|Android| C[Android Device]
    B -->|Forward to APNs| D[Apple APNs]
    D -->|iOS| E[iOS Device]
    C -->|Deliver| F[App - Background]
    E -->|Deliver| F
    F -->|User Taps| G[App - Foreground]
    G -->|Auto-join Call| H[WebRTC Connection]
```

## Firebase Setup

### Create Firebase Project

**Step 1: Firebase Console Setup**
1. Visit https://console.firebase.google.com
2. Click "Add project"
3. Name: "Walkie-Talkie"
4. Disable Google Analytics (optional)
5. Click "Create project"

**Step 2: Add Android App**
1. Click "Add app" → Android icon
2. Package name: com.yourcompany.walkietalkie (match build.gradle)
3. App nickname: "Walkie-Talkie Android"
4. Download google-services.json
5. Place in android/app/ directory

**Step 3: Add iOS App**
1. Click "Add app" → iOS icon
2. Bundle ID: com.yourcompany.walkietalkie (match Xcode)
3. App nickname: "Walkie-Talkie iOS"
4. Download GoogleService-Info.plist
5. Add to ios/Runner/ in Xcode (File > Add Files to "Runner")

**Step 4: Enable FCM**
1. Navigate to Project Settings → Cloud Messaging
2. Note Server Key and Sender ID (for backend)
3. For iOS: Upload APNs Authentication Key
   - Get APNs key from Apple Developer portal
   - Upload to Firebase (Settings → Cloud Messaging → APNs)

### Flutter Firebase Setup

**Add Dependencies:**
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.6
  flutter_local_notifications: ^16.3.0
```

**Android Configuration:**

`android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

`android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

`android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>

<application>
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_channel_id"
        android:value="walkie_talkie_calls" />
    
    <service
        android:name="io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService"
        android:exported="false" />
</application>
```

**iOS Configuration:**

`ios/Runner/AppDelegate.swift`:
```swift
import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    }
    
    application.registerForRemoteNotifications()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

`ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
    <string>fetch</string>
</array>
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

**Enable Capabilities in Xcode:**
1. Open ios/Runner.xcworkspace
2. Select Runner target
3. Go to Signing & Capabilities
4. Add "Push Notifications" capability
5. Add "Background Modes" capability
   - Enable "Remote notifications"

## APNs Configuration

### Apple Developer Portal Setup

**Step 1: Create APNs Key**
1. Login to developer.apple.com
2. Go to Certificates, Identifiers & Profiles
3. Click Keys → + (Create new key)
4. Name: "Walkie-Talkie APNs"
5. Enable Apple Push Notifications service (APNs)
6. Click Continue → Register
7. Download .p8 file (save securely, can't re-download)
8. Note Key ID and Team ID

**Step 2: Upload to Firebase**
1. Go to Firebase Console → Project Settings
2. Cloud Messaging tab
3. iOS app configuration section
4. Click "Upload" under APNs Authentication Key
5. Upload .p8 file
6. Enter Key ID and Team ID
7. Save

**Step 3: Configure App ID**
1. In Apple Developer Portal
2. Identifiers → Your App ID
3. Ensure "Push Notifications" is enabled
4. If not, enable and regenerate provisioning profile

## Backend FCM Integration

### Node.js Firebase Admin Setup

**Install Firebase Admin SDK:**
```bash
npm install firebase-admin
```

**Service Account Setup:**
1. Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key"
3. Download JSON file (e.g., firebase-adminsdk.json)
4. Store securely (DO NOT commit to git)
5. Reference in .env: `FIREBASE_SERVICE_ACCOUNT_PATH=./firebase-adminsdk.json`

**Environment Variables:**
```
FIREBASE_SERVICE_ACCOUNT_PATH=./config/firebase-adminsdk.json
FIREBASE_DATABASE_URL=https://walkie-talkie-xxxxx.firebaseio.com
```

**Initialize in Backend:**
- Import firebase-admin
- Initialize with service account credentials
- Store reference for sending notifications

## Notification Flow Implementation

### Device Token Management

**Flutter: Obtain FCM Token**
1. Call `FirebaseMessaging.instance.getToken()`
2. Store token in app state (Riverpod provider)
3. Send token to backend: `POST /api/users/device-token`
4. Backend stores token in database (users table)

**Token Refresh:**
- Listen to `FirebaseMessaging.instance.onTokenRefresh`
- Update backend with new token automatically
- Handle token refresh on app restart

### Backend: Send Notification

**Notification Trigger Scenarios:**
1. User A starts call, User B is offline/backgrounded
2. Incoming PTT message for idle user
3. Channel/group invitation

**Notification Payload Structure:**

For Data-Only (Background):
```json
{
  "token": "user_device_fcm_token",
  "data": {
    "type": "incoming_call",
    "channelId": "channel_123",
    "callerId": "user_abc",
    "callerName": "John Doe",
    "timestamp": "1699999999999",
    "priority": "high"
  }
}
```

For Notification + Data (Foreground/Background):
```json
{
  "token": "user_device_fcm_token",
  "notification": {
    "title": "Incoming Call",
    "body": "John Doe wants to talk",
    "sound": "default",
    "badge": "1"
  },
  "data": {
    "type": "incoming_call",
    "channelId": "channel_123",
    "callerId": "user_abc"
  },
  "android": {
    "priority": "high",
    "notification": {
      "channelId": "walkie_talkie_calls",
      "sound": "call_tone",
      "clickAction": "OPEN_CALL"
    }
  },
  "apns": {
    "headers": {
      "apns-priority": "10"
    },
    "payload": {
      "aps": {
        "sound": "call_tone.caf",
        "badge": 1,
        "category": "CALL_INVITE"
      }
    }
  }
}
```

### Flutter: Handle Incoming Notifications

**Three States to Handle:**
1. **Foreground**: App is open and visible
2. **Background**: App is minimized
3. **Terminated**: App is fully closed

**Message Handlers:**

1. **Foreground Handler**:
   - `FirebaseMessaging.onMessage.listen()`
   - Display in-app dialog or banner
   - Option to join call immediately

2. **Background Handler**:
   - `FirebaseMessaging.onBackgroundMessage()`
   - Show system notification via flutter_local_notifications
   - User taps → app opens with call context

3. **Terminated Handler**:
   - `FirebaseMessaging.instance.getInitialMessage()`
   - Check on app launch if opened via notification
   - Auto-navigate to call screen

## Local Notifications Setup

### Android Local Notification Channel

**Create Notification Channel:**
- Channel ID: "walkie_talkie_calls"
- Name: "Voice Calls"
- Importance: High
- Sound: Custom call tone (call_tone.mp3)
- Vibration: Enabled

**Flutter Implementation:**
- Initialize flutter_local_notifications plugin
- Create Android channel on app start
- Reference channel ID in FCM payload

### iOS Local Notification

**Custom Sound:**
1. Add call_tone.caf to ios/Runner/Resources/
2. Reference in notification payload
3. Ensure duration < 30 seconds

**Notification Categories:**
- Create UNNotificationCategory for "CALL_INVITE"
- Add actions: "Accept", "Decline"
- Handle action responses in Flutter

## Push Notification Lifecycle

```mermaid
sequenceDiagram
    participant A as User A
    participant Backend
    participant FCM
    participant APNs
    participant B as User B (Offline)
    
    A->>Backend: Start call (PTT pressed)
    Backend->>Backend: Check User B status
    alt User B offline
        Backend->>Backend: Query User B FCM token
        Backend->>FCM: Send notification payload
        FCM->>FCM: Route to platform
        
        alt Android
            FCM->>B: Deliver FCM message
        else iOS
            FCM->>APNs: Forward via APNs
            APNs->>B: Deliver APNs notification
        end
        
        Note over B: User sees notification
        B->>B: Tap notification
        B->>Backend: App reopens, fetch call details
        Backend-->>B: Channel info, caller data
        B->>B: Auto-join call (WebRTC)
        B->>A: Connected
    end
```

## Notification Best Practices

1. **High Priority for Calls**: Set priority: "high" for time-sensitive calls
2. **Custom Sounds**: Use distinct sounds for calls vs messages
3. **Notification Channels**: Separate channels for calls, messages, alerts (Android)
4. **Badge Management**: Update badge count, clear on app open
5. **Token Lifecycle**: Update token on change, handle token revocation
6. **Throttling**: Limit notification frequency to avoid spam
7. **Localization**: Send localized notification text
8. **Deep Linking**: Include proper data to navigate user to correct screen

## Common Notification Issues

**Issue 1: Notifications Not Received**
- **Android**: Check google-services.json in android/app/
- **iOS**: Verify APNs key uploaded, provisioning profile includes push
- **Both**: Ensure device token sent to backend, token valid

**Issue 2: iOS Notifications Silent**
- **Cause**: Sound file format incorrect or missing
- **Solution**: Use .caf format, max 30 seconds, add to Xcode bundle

**Issue 3: Background Notifications Not Working**
- **Android**: Check background restriction settings on device
- **iOS**: Verify "Background Modes - Remote notifications" enabled
- **Both**: Test with device, not simulator

**Issue 4: Token Refresh Not Detected**
- **Solution**: Implement onTokenRefresh listener, update backend immediately
- **Fallback**: Check and update token on each app launch

**Issue 5: Notification Actions Not Working**
- **Android**: Create notification categories and action buttons
- **iOS**: Implement UNNotificationCategory, handle actions in delegate

## Security Considerations

1. **Token Protection**: Never expose FCM server key client-side
2. **Validation**: Backend should validate sender before sending notification
3. **Rate Limiting**: Limit notifications per user to prevent abuse
4. **Data Privacy**: Don't include sensitive info in notification body
5. **Token Rotation**: Implement automatic token refresh on security events
6. **Encryption**: Use HTTPS for all token transmission

## Testing Notifications

**Development Testing:**
1. Use Firebase Console "Cloud Messaging" tab to send test notifications
2. Test with both debug and release builds
3. Test all three states: foreground, background, terminated

**Production Testing:**
1. Test on real devices (simulators have limitations)
2. Test with poor network conditions
3. Verify notification delivery time (<5 seconds)
4. Test token refresh scenarios
      `
    },
    {
      id: 'database',
      title: '7. Database Schema & Backend APIs',
      content: `
## PostgreSQL Database Design

### Schema Overview

The database stores user profiles, channels/groups, session history, and device tokens for push notifications.

### Core Tables

**1. users**
```
Table: users
Columns:
- id (UUID, PRIMARY KEY, DEFAULT gen_random_uuid())
- auth0_id (VARCHAR(255), UNIQUE, NOT NULL) - Auth0 user identifier
- email (VARCHAR(255), UNIQUE)
- name (VARCHAR(255))
- profile_picture (TEXT) - URL to profile image
- created_at (TIMESTAMP, DEFAULT NOW())
- updated_at (TIMESTAMP, DEFAULT NOW())
- last_login (TIMESTAMP)
- is_online (BOOLEAN, DEFAULT false)
- status (VARCHAR(50)) - 'active', 'busy', 'offline'

Indexes:
- idx_users_auth0_id ON users(auth0_id)
- idx_users_email ON users(email)
```

**2. device_tokens**
```
Table: device_tokens
Columns:
- id (UUID, PRIMARY KEY, DEFAULT gen_random_uuid())
- user_id (UUID, FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE)
- token (TEXT, NOT NULL, UNIQUE)
- platform (VARCHAR(10)) - 'android' or 'ios'
- device_info (JSONB) - Device model, OS version, etc.
- created_at (TIMESTAMP, DEFAULT NOW())
- updated_at (TIMESTAMP, DEFAULT NOW())
- is_active (BOOLEAN, DEFAULT true)

Indexes:
- idx_device_tokens_user_id ON device_tokens(user_id)
- idx_device_tokens_token ON device_tokens(token)
```

**3. channels**
```
Table: channels
Columns:
- id (UUID, PRIMARY KEY, DEFAULT gen_random_uuid())
- channel_code (VARCHAR(50), UNIQUE) - Human-readable join code
- name (VARCHAR(255))
- type (VARCHAR(20)) - 'duo', 'group', 'public'
- owner_id (UUID, FOREIGN KEY REFERENCES users(id))
- max_participants (INTEGER, DEFAULT 10)
- is_active (BOOLEAN, DEFAULT true)
- created_at (TIMESTAMP, DEFAULT NOW())
- updated_at (TIMESTAMP, DEFAULT NOW())

Indexes:
- idx_channels_code ON channels(channel_code)
- idx_channels_type ON channels(type)
- idx_channels_owner ON channels(owner_id)
```

**4. channel_members**
```
Table: channel_members
Columns:
- id (UUID, PRIMARY KEY, DEFAULT gen_random_uuid())
- channel_id (UUID, FOREIGN KEY REFERENCES channels(id) ON DELETE CASCADE)
- user_id (UUID, FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE)
- role (VARCHAR(20)) - 'owner', 'admin', 'member'
- joined_at (TIMESTAMP, DEFAULT NOW())
- is_muted (BOOLEAN, DEFAULT false)

Indexes:
- idx_channel_members_channel ON channel_members(channel_id)
- idx_channel_members_user ON channel_members(user_id)
- unique_channel_user ON channel_members(channel_id, user_id) UNIQUE
```

**5. duo_connections**
```
Table: duo_connections
Columns:
- id (UUID, PRIMARY KEY, DEFAULT gen_random_uuid())
- user1_id (UUID, FOREIGN KEY REFERENCES users(id))
- user2_id (UUID, FOREIGN KEY REFERENCES users(id))
- channel_id (UUID, FOREIGN KEY REFERENCES channels(id))
- status (VARCHAR(20)) - 'pending', 'connected', 'ended'
- created_at (TIMESTAMP, DEFAULT NOW())
- ended_at (TIMESTAMP)

Indexes:
- idx_duo_connections_users ON duo_connections(user1_id, user2_id)
```

**6. call_sessions**
```
Table: call_sessions
Columns:
- id (UUID, PRIMARY KEY, DEFAULT gen_random_uuid())
- channel_id (UUID, FOREIGN KEY REFERENCES channels(id))
- initiator_id (UUID, FOREIGN KEY REFERENCES users(id))
- started_at (TIMESTAMP, DEFAULT NOW())
- ended_at (TIMESTAMP)
- duration_seconds (INTEGER)
- participant_count (INTEGER)
- total_speaking_time (INTEGER) - Total seconds of audio transmitted

Indexes:
- idx_call_sessions_channel ON call_sessions(channel_id)
- idx_call_sessions_started ON call_sessions(started_at)
```

**7. call_participants**
```
Table: call_participants
Columns:
- id (UUID, PRIMARY KEY, DEFAULT gen_random_uuid())
- session_id (UUID, FOREIGN KEY REFERENCES call_sessions(id) ON DELETE CASCADE)
- user_id (UUID, FOREIGN KEY REFERENCES users(id))
- joined_at (TIMESTAMP, DEFAULT NOW())
- left_at (TIMESTAMP)
- speaking_duration (INTEGER) - Seconds this user spoke

Indexes:
- idx_call_participants_session ON call_participants(session_id)
- idx_call_participants_user ON call_participants(user_id)
```

### Database Setup Instructions

**1. Install PostgreSQL:**
```bash
# Ubuntu/Debian
sudo apt-get install postgresql postgresql-contrib

# macOS (Homebrew)
brew install postgresql@15

# Start service
sudo systemctl start postgresql  # Linux
brew services start postgresql@15  # macOS
```

**2. Create Database:**
```sql
CREATE DATABASE walkietalkie;
CREATE USER walkietalkie_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE walkietalkie TO walkietalkie_user;
```

**3. Environment Variables:**
```
DATABASE_URL=postgresql://walkietalkie_user:your_secure_password@localhost:5432/walkietalkie
DATABASE_POOL_MIN=2
DATABASE_POOL_MAX=10
```

**4. Run Migrations:**
- Use Sequelize or Prisma for schema migrations
- Create migration files for each table
- Run: `npx sequelize-cli db:migrate` or `npx prisma migrate deploy`

## Backend REST API Endpoints

### Base URL Structure
```
Production: https://api.walkietalkie.com
Development: http://localhost:3000
```

### Authentication Endpoints

**POST /api/auth/register**
- Purpose: Register device token and sync user from Auth0
- Headers: Authorization: Bearer {JWT}
- Body: {deviceToken: string, platform: 'android'|'ios', deviceInfo: object}
- Response: {userId: UUID, status: 'registered'}

**POST /api/auth/logout**
- Purpose: Remove device token, clear session
- Headers: Authorization: Bearer {JWT}
- Response: {status: 'logged_out'}

### User Endpoints

**GET /api/users/me**
- Purpose: Get current user profile
- Headers: Authorization: Bearer {JWT}
- Response: User object with profile data

**PUT /api/users/me**
- Purpose: Update user profile (name, status)
- Headers: Authorization: Bearer {JWT}
- Body: {name?: string, status?: string}
- Response: Updated user object

**GET /api/users/search?q={query}**
- Purpose: Search users by email or name
- Headers: Authorization: Bearer {JWT}
- Query: q (search term)
- Response: Array of user objects

**PUT /api/users/me/status**
- Purpose: Update online status
- Headers: Authorization: Bearer {JWT}
- Body: {isOnline: boolean, status: 'active'|'busy'|'offline'}
- Response: {status: 'updated'}

### Channel Endpoints

**POST /api/channels/duo/initiate**
- Purpose: Create or get existing duo channel with friend
- Headers: Authorization: Bearer {JWT}
- Body: {friendUserId: UUID}
- Response: {channelId: UUID, channelCode: string, status: 'created'|'existing'}

**POST /api/channels/group/create**
- Purpose: Create new group channel
- Headers: Authorization: Bearer {JWT}
- Body: {name: string, maxParticipants?: number}
- Response: {channelId: UUID, channelCode: string, inviteLink: string}

**POST /api/channels/group/join**
- Purpose: Join group channel by code
- Headers: Authorization: Bearer {JWT}
- Body: {channelCode: string}
- Response: {channelId: UUID, channelInfo: object}

**GET /api/channels/my-channels**
- Purpose: Get user's active channels
- Headers: Authorization: Bearer {JWT}
- Response: Array of channel objects with member info

**GET /api/channels/:channelId**
- Purpose: Get channel details
- Headers: Authorization: Bearer {JWT}
- Params: channelId (UUID)
- Response: Channel object with members

**DELETE /api/channels/:channelId/leave**
- Purpose: Leave a channel
- Headers: Authorization: Bearer {JWT}
- Params: channelId (UUID)
- Response: {status: 'left'}

**GET /api/channels/public/random**
- Purpose: Get random public channel
- Headers: Authorization: Bearer {JWT}
- Response: Channel object

### Call Session Endpoints

**POST /api/sessions/start**
- Purpose: Log call session start
- Headers: Authorization: Bearer {JWT}
- Body: {channelId: UUID}
- Response: {sessionId: UUID, startedAt: timestamp}

**PUT /api/sessions/:sessionId/end**
- Purpose: Log call session end
- Headers: Authorization: Bearer {JWT}
- Params: sessionId (UUID)
- Body: {duration: number, speakingTime: number}
- Response: {status: 'ended'}

**GET /api/sessions/history?limit=20&offset=0**
- Purpose: Get user's call history
- Headers: Authorization: Bearer {JWT}
- Query: limit, offset (pagination)
- Response: Array of session objects

### TURN Credentials Endpoint

**GET /api/turn/credentials**
- Purpose: Get temporary TURN server credentials
- Headers: Authorization: Bearer {JWT}
- Response: {urls: array, username: string, credential: string, ttl: number}

## Backend Implementation Notes

### JWT Validation Middleware

**For Every Protected Route:**
1. Extract JWT from Authorization header
2. Verify signature using Auth0 JWKS endpoint
3. Check token expiration
4. Validate issuer and audience
5. Extract user ID from `sub` claim
6. Attach user object to request

### Error Handling

**Standard Error Response Format:**
```json
{
  "error": {
    "code": "CHANNEL_NOT_FOUND",
    "message": "The requested channel does not exist",
    "statusCode": 404
  }
}
```

**Common Error Codes:**
- UNAUTHORIZED (401)
- FORBIDDEN (403)
- NOT_FOUND (404)
- CHANNEL_FULL (409)
- VALIDATION_ERROR (422)
- INTERNAL_SERVER_ERROR (500)

### Rate Limiting

**Implement Rate Limits:**
- Authentication: 5 requests/minute
- API endpoints: 100 requests/minute per user
- WebSocket connections: 10 connections per user
- Use express-rate-limit or similar middleware

### Logging

**Log Important Events:**
- User authentication (success/failure)
- Channel creation/joining
- Call sessions (start/end)
- WebSocket connections/disconnections
- Errors and exceptions

**Log Format (JSON):**
```json
{
  "timestamp": "2025-11-03T10:30:00Z",
  "level": "info",
  "message": "User joined channel",
  "userId": "user-123",
  "channelId": "channel-456",
  "metadata": {}
}
```

### Database Connection Pooling

**Configuration:**
- Minimum connections: 2
- Maximum connections: 10
- Idle timeout: 30 seconds
- Connection timeout: 5 seconds

### CORS Configuration

```
Allowed Origins: https://walkietalkie.com, http://localhost:* (dev only)
Allowed Methods: GET, POST, PUT, DELETE, OPTIONS
Allowed Headers: Authorization, Content-Type
Credentials: true (for cookies/auth)
```
      `
    },
    {
      id: 'riverpod',
      title: '8. State Management with Riverpod',
      content: `
## Riverpod Architecture

Riverpod provides a robust, compile-safe state management solution for Flutter. This section outlines the provider structure for the walkie-talkie app.

### Provider Categories

1. **Authentication Providers**: User auth state, tokens
2. **WebRTC Providers**: Peer connections, media streams
3. **Socket Providers**: WebSocket connection, signaling
4. **Channel Providers**: Current channel, members
5. **UI State Providers**: Loading states, errors, notifications

### Core Providers Structure

**1. Authentication Providers**

```
authRepositoryProvider (Provider)
- Provides: AuthRepository instance (Auth0 wrapper)
- Scope: Global, never disposed

authStateProvider (StreamProvider)
- Provides: Stream<AuthState> (authenticated/unauthenticated/loading)
- Dependencies: authRepositoryProvider
- Listens to: Auth0 auth state changes

currentUserProvider (FutureProvider)
- Provides: Future<User?> current user data
- Dependencies: authStateProvider, apiClient
- Auto-refresh: When auth state changes

accessTokenProvider (FutureProvider)
- Provides: Future<String> valid JWT access token
- Dependencies: authRepositoryProvider
- Auto-refresh: Before token expiry
```

**2. WebRTC Providers**

```
webrtcServiceProvider (Provider)
- Provides: WebRTCService instance
- Scope: Global, disposed on logout
- Manages: Peer connection lifecycle

localMediaStreamProvider (StateProvider)
- Provides: MediaStream? from microphone
- State: null (not recording) | MediaStream (recording)

peerConnectionsProvider (StateNotifierProvider)
- Provides: Map<String, RTCPeerConnection> (userId -> connection)
- Manages: Multiple peer connections for group calls

connectionStatusProvider (StateProvider)
- Provides: ConnectionStatus enum (disconnected/connecting/connected/failed)
- Updates: On peer connection state changes

activeSpeakerProvider (StateProvider)
- Provides: String? userId of current speaker
- Updates: From Socket.io events
```

**3. Socket.io Providers**

```
socketServiceProvider (Provider)
- Provides: SocketService instance
- Auto-connect: When authenticated
- Auto-reconnect: On disconnect

socketConnectionProvider (StreamProvider)
- Provides: Stream<SocketStatus> (connected/disconnected/error)
- Dependencies: socketServiceProvider
- Listens to: Socket connect/disconnect events

currentChannelProvider (StateNotifierProvider)
- Provides: Channel? current active channel
- Manages: Channel state, members list
- Updates: From Socket.io channel events
```

**4. Channel Providers**

```
channelListProvider (FutureProvider)
- Provides: Future<List<Channel>> user's channels
- Dependencies: apiClient, currentUserProvider
- Cached: 5 minutes, invalidate on channel join/leave

channelMembersProvider (StreamProvider, family)
- Provides: Stream<List<User>> for specific channel
- Parameter: String channelId
- Listens to: Socket.io member join/leave events

duoConnectionProvider (StateNotifierProvider)
- Provides: DuoConnection? current duo call
- Manages: Duo-specific state (friend info, connection)
```

**5. UI State Providers**

```
loadingStateProvider (StateProvider)
- Provides: bool isLoading
- Used for: Global loading overlay

errorMessageProvider (StateProvider)
- Provides: String? error message
- Auto-clear: After 5 seconds

notificationProvider (StreamProvider)
- Provides: Stream<AppNotification> in-app notifications
- Listens to: FCM foreground messages
```

### Provider Dependencies Map

```mermaid
graph TD
    A[authRepositoryProvider] --> B[authStateProvider]
    B --> C[currentUserProvider]
    B --> D[accessTokenProvider]
    
    D --> E[apiClientProvider]
    E --> F[channelListProvider]
    
    B --> G[socketServiceProvider]
    G --> H[socketConnectionProvider]
    G --> I[currentChannelProvider]
    
    I --> J[webrtcServiceProvider]
    J --> K[peerConnectionsProvider]
    J --> L[localMediaStreamProvider]
    
    H --> M[channelMembersProvider]
    I --> M
```

## Riverpod Implementation Patterns

### Pattern 1: Repository Pattern

**AuthRepository Example:**
- Wraps Auth0 SDK operations
- Provides clean interface for login, logout, token refresh
- Handles token storage (FlutterSecureStorage)
- Emits auth state changes via Stream

### Pattern 2: StateNotifier for Complex State

**ChannelStateNotifier Example:**
- Manages current channel state
- Methods: joinChannel, leaveChannel, updateMembers
- Emits new state on each change
- Handles side effects (Socket.io emit, API calls)

### Pattern 3: Family Providers for Dynamic Data

**channelMembersProvider(channelId):**
- Create separate provider instance per channel ID
- Cache data per channel
- Auto-dispose when no longer watched

### Pattern 4: FutureProvider with Auto-Invalidation

**channelListProvider:**
- Fetch from API once
- Cache result
- Invalidate and refetch when:
  - User joins new channel
  - User leaves channel
  - Manual refresh triggered

## Riverpod Lifecycle Management

**App Initialization:**
1. Create ProviderContainer (main.dart)
2. Initialize Firebase (before runApp)
3. Run app with ProviderScope

**Logout Flow:**
1. Dispose WebRTC service
2. Close Socket connection
3. Clear auth tokens
4. Invalidate all user-specific providers
5. Navigate to login screen

**Provider Disposal:**
- Auto-dispose: Enabled for expensive providers (WebRTC, Sockets)
- Keep-alive: Auth state, theme, global config
- Manual disposal: On logout or app termination

## Common Riverpod Patterns

### Loading States

```
// In Widget:
final channelsAsync = ref.watch(channelListProvider);

channelsAsync.when(
  data: (channels) => ListView.builder(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
);
```

### Refreshing Data

```
// Pull-to-refresh:
onRefresh: () => ref.refresh(channelListProvider.future)

// Manual invalidate:
ref.invalidate(channelListProvider)
```

### Listening to Changes

```
// Show snackbar on error:
ref.listen<AsyncValue>(someProvider, (previous, next) {
  if (next.hasError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error.toString()))
    );
  }
});
```

### Combining Multiple Providers

```
final userInChannelProvider = Provider((ref) {
  final user = ref.watch(currentUserProvider).value;
  final channel = ref.watch(currentChannelProvider);
  
  if (user == null || channel == null) return false;
  return channel.members.contains(user.id);
});
```

## Testing with Riverpod

**Override Providers in Tests:**
- Create ProviderContainer with overrides
- Mock repository/service providers
- Test state changes and side effects

**Integration Tests:**
- Override API client with mock responses
- Test full user flows with real providers
- Verify provider interactions
      `
    },
    {
      id: 'flows',
      title: '9. Detailed Flow Diagrams',
      content: `
## Complete User Flows

### Flow 1: Channel Creation and Joining

```mermaid
graph TD
    Start[User Opens App] --> Auth{Authenticated?}
    Auth -->|No| Login[Login Screen]
    Login --> GoogleAuth[Google Sign-In via Auth0]
    GoogleAuth --> StoreToken[Store JWT]
    Auth -->|Yes| Dashboard[Dashboard Screen]
    StoreToken --> Dashboard
    
    Dashboard --> ModeSelect{Select Mode}
    ModeSelect -->|Duo| EnterFriendID[Enter Friend ID]
    ModeSelect -->|Group| GroupOptions{Create or Join?}
    ModeSelect -->|Public| RandomChannel[Get Random Channel]
    
    EnterFriendID --> SearchUser[API: Search User]
    SearchUser --> UserFound{User Exists?}
    UserFound -->|No| ShowError[Show Error]
    UserFound -->|Yes| CreateDuo[API: Create Duo Channel]
    CreateDuo --> ChannelReady[Channel Created]
    
    GroupOptions -->|Create| CreateGroup[Enter Group Name]
    CreateGroup --> APICreateGroup[API: Create Group Channel]
    APICreateGroup --> ShareCode[Show Invite Code]
    ShareCode --> ChannelReady
    
    GroupOptions -->|Join| EnterCode[Enter Channel Code]
    EnterCode --> APIJoinGroup[API: Join Group]
    APIJoinGroup --> ChannelValid{Valid Code?}
    ChannelValid -->|No| ShowError
    ChannelValid -->|Yes| ChannelReady
    
    RandomChannel --> APIRandom[API: Get Random Public Channel]
    APIRandom --> ChannelReady
    
    ChannelReady --> ConnectSocket[WebSocket: Join Channel]
    ConnectSocket --> WaitForPeers[Wait for Other Users]
    WaitForPeers --> ShowChannelUI[Show Call Screen]
```

### Flow 2: Push-to-Talk Full Cycle

```mermaid
sequenceDiagram
    participant U as User
    participant UI as Flutter UI
    participant WS as WebRTC Service
    participant S as Socket.io
    participant Server as Backend
    participant Peer as Other User
    
    U->>UI: Press PTT Button
    UI->>UI: Check Microphone Permission
    alt Permission Granted
        UI->>WS: startCapture()
        WS->>WS: getUserMedia({audio: true})
        WS-->>UI: MediaStream obtained
        
        UI->>S: emit('start-speaking', {channelId, userId})
        S->>Server: Forward speaking event
        Server->>Peer: notify speaking-started
        
        Peer->>Peer: Show "User Speaking" indicator
        
        Note over WS,Peer: WebRTC negotiation if not connected
        
        WS->>WS: Create offer
        WS->>S: emit('offer', {sdp, targetUserId})
        S->>Server: Forward offer
        Server->>Peer: deliver offer
        
        Peer->>Peer: Create answer
        Peer->>Server: send answer
        Server->>WS: deliver answer
        
        WS->>WS: Set remote description
        
        Note over WS,Peer: ICE candidates exchange
        
        WS->>Server: emit ICE candidates
        Server->>Peer: forward candidates
        Peer->>Server: send candidates
        Server->>WS: deliver candidates
        
        Note over WS,Peer: Connection established
        
        loop Audio streaming
            WS->>Peer: RTP audio packets
        end
        
        U->>UI: Release PTT Button
        UI->>WS: stopCapture()
        WS->>WS: Stop media tracks
        UI->>S: emit('stop-speaking')
        S->>Server: Forward stop event
        Server->>Peer: notify speaking-stopped
        Peer->>Peer: Hide "User Speaking" indicator
    else Permission Denied
        UI->>U: Show Permission Dialog
    end
```

### Flow 3: Incoming Call Notification

```mermaid
sequenceDiagram
    participant UA as User A (Caller)
    participant Backend
    participant FCM as Firebase FCM
    participant UB as User B (Receiver)
    participant App as B's App
    
    UA->>Backend: Start Call (PTT pressed)
    Backend->>Backend: Check if User B online
    alt User B Offline/Background
        Backend->>Backend: Query User B FCM token
        Backend->>FCM: Send push notification
        Note over FCM: {<br/>  title: "Incoming Call",<br/>  body: "User A wants to talk",<br/>  data: {channelId, callerId}<br/>}
        
        FCM->>UB: Deliver notification
        
        UB->>UB: User sees notification
        UB->>App: Tap notification
        
        alt App Terminated
            App->>App: Launch app with notification data
            App->>App: getInitialMessage()
            App->>Backend: Fetch channel details
            Backend-->>App: Channel info
        else App Background
            App->>App: onMessageOpenedApp()
            App->>Backend: Fetch channel details
            Backend-->>App: Channel info
        end
        
        App->>App: Navigate to Call Screen
        App->>Backend: WebSocket: Join channel
        Backend-->>UA: notify User B joined
        App->>UA: Establish WebRTC connection
        UA->>UB: Audio stream starts
    else User B Online
        Backend->>UB: Direct Socket.io event
        UB->>UB: Show in-app call dialog
    end
```

### Flow 4: Token Refresh and Re-authentication

```mermaid
graph TD
    Start[App Makes API Request] --> CheckToken{Token Valid?}
    CheckToken -->|Yes| MakeRequest[Make API Request]
    MakeRequest --> Success[Request Successful]
    
    CheckToken -->|Expiring Soon| RefreshToken[Auth0: Refresh Token]
    RefreshToken --> RefreshSuccess{Refresh Success?}
    RefreshSuccess -->|Yes| StoreNew[Store New Access Token]
    StoreNew --> MakeRequest
    
    RefreshSuccess -->|No| ClearTokens[Clear All Tokens]
    ClearTokens --> ShowLogin[Navigate to Login]
    
    CheckToken -->|Expired| TryRefresh[Attempt Refresh]
    TryRefresh --> RefreshSuccess
    
    MakeRequest --> ResponseCheck{Response Status}
    ResponseCheck -->|401 Unauthorized| ClearTokens
    ResponseCheck -->|Success| Success
    ResponseCheck -->|Other Error| HandleError[Show Error Message]
```

### Flow 5: Background Audio Continuation

```mermaid
sequenceDiagram
    participant User
    participant App
    participant OS as Operating System
    participant Audio as Audio Service
    participant Socket
    
    User->>App: Active call in progress
    Note over App,Audio: Audio streaming via WebRTC
    
    User->>OS: Press Home button
    OS->>App: App lifecycle: paused
    
    App->>Audio: Continue background audio
    Note over Audio: Foreground service (Android)<br/>Background audio mode (iOS)
    
    Audio->>OS: Show persistent notification
    OS->>User: Display notification with "Stop" button
    
    Note over Socket,Audio: WebRTC connection maintained
    
    loop While in background
        Socket->>Audio: Receive audio packets
        Audio->>OS: Play audio output
    end
    
    alt User returns to app
        User->>OS: Tap app icon or notification
        OS->>App: App lifecycle: resumed
        App->>App: Restore UI state
        App->>User: Show call screen
    else User stops call
        User->>OS: Tap "Stop" on notification
        OS->>Audio: Stop audio service
        Audio->>Socket: Disconnect WebRTC
        Audio->>App: Clear notification
        Socket->>Socket: Leave channel
    end
```

### Flow 6: Error Handling and Recovery

```mermaid
graph TD
    Normal[Normal Operation] --> Error{Error Occurs}
    
    Error -->|Network Lost| DetectDisconnect[Detect Socket Disconnect]
    DetectDisconnect --> ShowOffline[Show "Offline" Indicator]
    ShowOffline --> AttemptReconnect[Auto Reconnect Attempts]
    AttemptReconnect --> ReconnectSuccess{Reconnected?}
    ReconnectSuccess -->|Yes| Rejoin[Rejoin Last Channel]
    Rejoin --> RestoreState[Restore UI State]
    RestoreState --> Normal
    ReconnectSuccess -->|No| ShowRetry[Show "Retry" Button]
    ShowRetry --> UserRetry{User Taps Retry?}
    UserRetry -->|Yes| AttemptReconnect
    UserRetry -->|No| StayOffline[Stay Offline Mode]
    
    Error -->|WebRTC Failure| CloseConnection[Close Peer Connection]
    CloseConnection --> ICERestart[Initiate ICE Restart]
    ICERestart --> RenegotiateSuccess{Renegotiate Success?}
    RenegotiateSuccess -->|Yes| Normal
    RenegotiateSuccess -->|No| NotifyUser[Show "Connection Failed"]
    NotifyUser --> OfferLeave[Offer to Leave Channel]
    
    Error -->|Token Expired| RefreshAttempt[Try Token Refresh]
    RefreshAttempt --> RefreshWorks{Refresh Success?}
    RefreshWorks -->|Yes| Normal
    RefreshWorks -->|No| ForceLogout[Clear Session, Logout]
    ForceLogout --> LoginScreen[Navigate to Login]
    
    Error -->|Channel Full| ShowFullError[Show "Channel Full" Message]
    ShowFullError --> OfferAlternative[Suggest Create New Channel]
    
    Error -->|API Error| ParseError[Parse Error Response]
    ParseError --> ShowMessage[Show User-Friendly Message]
    ShowMessage --> LogError[Log to Backend]
```

## UI State Flow

### Call Screen State Machine

```
States:
- IDLE: Not in call, no connection
- CONNECTING: Joining channel, establishing WebRTC
- CONNECTED: Ready to talk/listen
- SPEAKING: User is transmitting audio
- LISTENING: Receiving audio from peer
- RECONNECTING: Connection lost, attempting restore
- ERROR: Unrecoverable error occurred

Transitions:
- IDLE → CONNECTING: User joins channel
- CONNECTING → CONNECTED: WebRTC established
- CONNECTING → ERROR: Connection failed
- CONNECTED → SPEAKING: PTT button pressed
- CONNECTED → LISTENING: Peer starts speaking
- SPEAKING → CONNECTED: PTT button released
- LISTENING → CONNECTED: Peer stops speaking
- CONNECTED → RECONNECTING: Network lost
- RECONNECTING → CONNECTED: Network restored
- ANY → IDLE: Leave channel
```
      `
    }
  ];

  const sections2 = [
    {
      id: 'integration',
      title: '10. Integration Steps & Setup',
      content: `
## Complete Integration Checklist

### Phase 1: Project Setup (Day 1-2)

**Flutter Project Initialization:**
1. Create new Flutter project: \`flutter create walkie_talkie\`
2. Update pubspec.yaml with all dependencies
3. Configure minimum SDK versions:
   - Android: minSdkVersion 21
   - iOS: iOS 12.0
4. Set up folder structure:
   - lib/core/ (constants, theme, utils)
   - lib/data/ (models, repositories)
   - lib/providers/ (Riverpod providers)
   - lib/services/ (Auth, WebRTC, Socket, API)
   - lib/presentation/ (screens, widgets)
5. Create .env file for environment variables

**Backend Project Initialization:**
1. Create Node.js project: \`npm init\`
2. Install dependencies (express, socket.io, sequelize, etc.)
3. Set up folder structure:
   - src/config/ (database, auth, env)
   - src/controllers/ (API handlers)
   - src/middleware/ (auth, validation, error)
   - src/models/ (database models)
   - src/routes/ (API routes)
   - src/services/ (business logic)
   - src/sockets/ (Socket.io handlers)
4. Create .env file with all required variables
5. Initialize PostgreSQL database

### Phase 2: Authentication Integration (Day 3-5)

**Auth0 Configuration:**
1. Complete all Auth0 dashboard setup steps (see section 4)
2. Configure Google OAuth connection
3. Create Auth0 application (Native type)
4. Set up allowed callback/logout URLs
5. Create API for backend validation
6. Download Auth0 configuration files

**Flutter Auth0 Setup:**
1. Add auth0_flutter package
2. Configure Android: Add manifest placeholders
3. Configure iOS: Add URL scheme to Info.plist
4. Create AuthRepository with Auth0 wrapper
5. Implement login/logout methods
6. Create Riverpod providers for auth state
7. Add FlutterSecureStorage for token persistence
8. Test login flow on both platforms

**Backend Auth0 Integration:**
1. Install express-jwt and jwks-rsa
2. Create JWT validation middleware
3. Configure Auth0 domain and audience
4. Implement token verification
5. Create user sync endpoint (/api/auth/register)
6. Test JWT validation with Postman
7. Handle token refresh logic

**Integration Test:**
- User logs in via Google → receives JWT → token validated on backend → user registered in DB

### Phase 3: Database & API Setup (Day 6-8)

**PostgreSQL Setup:**
1. Install PostgreSQL on development machine
2. Create database and user
3. Install Sequelize or Prisma ORM
4. Create all database tables (see section 7 schema)
5. Write migration files
6. Run migrations
7. Seed test data (optional)

**REST API Implementation:**
1. Set up Express routes for all endpoints
2. Implement user endpoints (GET /users/me, etc.)
3. Implement channel endpoints (create, join, list)
4. Implement session logging endpoints
5. Add request validation middleware
6. Add error handling middleware
7. Test all endpoints with Postman

**Flutter API Client:**
1. Create API client service using http package
2. Add JWT token to all requests (interceptor)
3. Implement retry logic for failed requests
4. Create Riverpod providers for API data
5. Test API calls from app

**Integration Test:**
- App makes authenticated API request → backend validates token → queries database → returns data

### Phase 4: WebRTC & Socket.io Integration (Day 9-15)

**Backend Socket.io Setup:**
1. Install socket.io
2. Attach to Express server
3. Implement JWT authentication middleware for sockets
4. Create room management logic
5. Implement signaling event handlers (offer, answer, ICE)
6. Add presence tracking (user joined/left)
7. Test with Socket.io client tool

**Flutter Socket.io Integration:**
1. Add socket_io_client package
2. Create SocketService class
3. Connect to backend with JWT in options
4. Implement event listeners (offer, answer, ICE, etc.)
5. Create Riverpod providers for socket state
6. Handle reconnection logic
7. Test connection and events

**Flutter WebRTC Integration:**
1. Add flutter_webrtc package
2. Request microphone permissions
3. Create WebRTCService class
4. Implement getUserMedia for audio capture
5. Create RTCPeerConnection with ICE config
6. Implement offer/answer creation
7. Handle ICE candidate exchange
8. Connect audio track to peer connection
9. Implement audio playback
10. Create Riverpod providers for WebRTC state

**TURN Server Setup:**
1. Choose TURN provider (Twilio recommended)
2. Sign up and get credentials
3. Configure ICE servers in Flutter app
4. Implement credential fetch endpoint on backend
5. Test NAT traversal

**Integration Test:**
- Two devices connect to same channel → Socket.io signaling → WebRTC connection → audio streams both ways

### Phase 5: Push Notifications Integration (Day 16-18)

**Firebase Project Setup:**
1. Create Firebase project
2. Add Android app (download google-services.json)
3. Add iOS app (download GoogleService-Info.plist)
4. Enable Cloud Messaging
5. Upload APNs key for iOS
6. Note server key and sender ID

**Flutter FCM Setup:**
1. Add firebase_core and firebase_messaging packages
2. Configure Android (build.gradle, manifest)
3. Configure iOS (AppDelegate, Info.plist)
4. Enable push notifications capability in Xcode
5. Initialize Firebase in main.dart
6. Request notification permissions
7. Get FCM token
8. Send token to backend
9. Implement foreground/background/terminated handlers
10. Test notification reception

**Backend FCM Integration:**
1. Install firebase-admin
2. Download service account JSON
3. Initialize Firebase Admin SDK
4. Implement notification send function
5. Create endpoint to trigger notifications
6. Add notification logic to call initiation
7. Test sending notifications

**iOS APNs Configuration:**
1. Create APNs key in Apple Developer portal
2. Upload to Firebase Console
3. Configure app for remote notifications
4. Test iOS notification delivery

**Integration Test:**
- User A starts call, User B offline → Backend sends FCM notification → User B receives notification → taps → app opens and joins call

### Phase 6: UI & Theme Implementation (Day 19-21)

**Theme Setup:**
1. Add google_fonts package
2. Create colors.dart with color palette
3. Create app_theme.dart with ThemeData
4. Configure DM Serif Text font
5. Apply theme in MaterialApp

**Core Widgets:**
1. Create PTT button widget (press/hold logic)
2. Create audio visualizer widget
3. Create contact list item widget
4. Create channel card widget
5. Create custom app bar
6. Create dialogs (join channel, create group)

**Screens:**
1. Login screen
2. Dashboard with tabs (Duo, Group, Public)
3. Duo screen (friend search, connect)
4. Group screen (create, join, list)
5. Public screen (dial UI for random channels)
6. Call screen (PTT button, visualizer)
7. Settings screen

**Navigation:**
1. Set up routing (go_router or Navigator 2.0)
2. Implement tab navigation
3. Handle deep links from notifications
4. Implement back button handling

### Phase 7: Background Service & Audio (Day 22-24)

**Android Background Service:**
1. Add flutter_background_service package
2. Configure foreground service in manifest
3. Add required permissions
4. Create persistent notification
5. Keep WebRTC connection alive in background
6. Test background audio playback

**iOS Background Audio:**
1. Enable background modes in Xcode
2. Configure AVAudioSession
3. Test background audio playback
4. Handle audio interruptions (phone calls)

**Notification Actions:**
1. Create notification channels (Android)
2. Add action buttons (Accept, Decline)
3. Handle notification taps
4. Test notification navigation

### Phase 8: Testing & Polish (Day 25-27)

**Unit Tests:**
1. Test Auth0 repository
2. Test API client
3. Test WebRTC service methods
4. Test Socket.io event handling
5. Test Riverpod state changes

**Integration Tests:**
1. Test complete auth flow
2. Test channel creation and joining
3. Test WebRTC connection establishment
4. Test audio streaming
5. Test push notifications

**Manual Testing:**
1. Test on multiple Android devices
2. Test on multiple iOS devices
3. Test with poor network conditions
4. Test background/foreground transitions
5. Test notification handling
6. Test simultaneous calls
7. Test group calls with max participants

**Polish:**
1. Add loading indicators
2. Improve error messages
3. Add haptic feedback
4. Optimize performance
5. Add analytics events (optional)
6. Test accessibility

### Phase 9: Deployment Preparation (Day 28-30)

**Backend Deployment:**
1. Choose hosting provider (AWS, DigitalOcean, Heroku)
2. Set up production database
3. Configure environment variables
4. Enable HTTPS
5. Set up CI/CD pipeline
6. Deploy backend
7. Test production endpoints

**Flutter Build:**
1. Update version numbers
2. Generate app icons
3. Create splash screens
4. Configure signing (Android keystore, iOS certificates)
5. Build release APK/AAB
6. Build iOS release archive
7. Test release builds

**Monitoring Setup:**
1. Add logging service (Sentry, Firebase Crashlytics)
2. Configure error reporting
3. Add performance monitoring
4. Set up backend monitoring (PM2, DataDog)

## Common Integration Issues

**Issue: Auth0 Callback Not Working**
- Solution: Verify callback URLs match exactly in Auth0 dashboard and app config
- Check URL schemes are configured correctly

**Issue: WebRTC Connection Fails**
- Solution: Check STUN/TURN server configuration
- Verify ICE candidates are being exchanged
- Test with different networks

**Issue: Notifications Not Received**
- Solution: Verify FCM token sent to backend
- Check google-services.json and GoogleService-Info.plist are added
- Test on real devices (not simulators)

**Issue: Background Audio Stops**
- Solution: Ensure foreground service is running (Android)
- Verify background modes enabled (iOS)
- Check audio session configuration

**Issue: Socket Disconnects Frequently**
- Solution: Implement proper reconnection logic
- Use heartbeat/ping mechanism
- Check server timeout settings
      `
    },
    {
      id: 'timeline',
      title: '11. One-Month Development Timeline',
      content: `
## 30-Day Development Schedule

### Week 1: Foundation & Setup (Days 1-7)

**Day 1: Project Initialization**
- **Lead Dev (You):**
  - Create Flutter project structure
  - Set up folder organization (lib/core, lib/data, lib/providers, etc.)
  - Add all dependencies to pubspec.yaml
  - Configure minimum SDK versions
  - Create color constants and theme files (colors.dart, app_theme.dart)
  - Set up google_fonts for DM Serif Text
  - Initialize Git repository
  - **Effort**: Medium
  - **Verification**: Run \`flutter pub get\` successfully, app builds with base theme

- **Developer 2 (Friend):**
  - Create Node.js backend project
  - Set up Express server boilerplate
  - Install all backend dependencies
  - Create folder structure (src/config, src/controllers, etc.)
  - Set up PostgreSQL database
  - Create database user and grant permissions
  - Initialize Git repository
  - **Effort**: Medium
  - **Verification**: Server starts without errors, database connection works

**Day 2: Auth0 Configuration**
- **Lead Dev:**
  - Create Auth0 account and tenant
  - Configure Google OAuth connection in Auth0
  - Create Auth0 Native application
  - Configure callback URLs and settings
  - Add auth0_flutter package
  - Configure Android manifest placeholders
  - Configure iOS URL schemes
  - **Effort**: Large
  - **Verification**: Auth0 app created, Flutter project configured for auth

- **Developer 2:**
  - Create Auth0 API in dashboard
  - Set up JWT validation middleware in Express
  - Install express-jwt and jwks-rsa packages
  - Configure Auth0 domain and audience in .env
  - Create basic protected route to test JWT validation
  - **Effort**: Medium
  - **Verification**: Backend can validate Auth0 JWT tokens

**Day 3: Authentication Implementation**
- **Lead Dev:**
  - Create AuthRepository class
  - Implement Auth0 login method
  - Implement Auth0 logout method
  - Add flutter_secure_storage for token storage
  - Create Riverpod auth state provider
  - Create Riverpod user provider
  - Build login screen UI
  - Add "Sign in with Google" button
  - **Effort**: Large
  - **Verification**: User can sign in with Google, JWT stored securely

- **Developer 2:**
  - Create User model (Sequelize/Prisma)
  - Run database migration for users table
  - Create POST /api/auth/register endpoint
  - Implement user creation/update on first login
  - Create GET /api/users/me endpoint
  - Add JWT validation to user endpoints
  - **Effort**: Large
  - **Verification**: User registered in database on first login

**Day 4: Database Schema**
- **Lead Dev:**
  - Create data models in Flutter (User, Channel, Session)
  - Create API client service
  - Implement HTTP interceptor for JWT
  - Create Riverpod provider for API client
  - Test API calls to backend
  - Handle 401 errors (token refresh logic)
  - **Effort**: Medium
  - **Verification**: App successfully makes authenticated API calls

- **Developer 2:**
  - Create all database tables (channels, channel_members, device_tokens, etc.)
  - Write and run migrations for all tables
  - Add indexes for performance
  - Create database seed file with test data
  - Document database schema
  - **Effort**: Large
  - **Verification**: All tables created, indexes in place, queries perform well

**Day 5: REST API Endpoints**
- **Lead Dev:**
  - Implement user search functionality in UI
  - Create channel list screen skeleton
  - Add pull-to-refresh for data
  - Implement error handling and display
  - Create loading state indicators
  - **Effort**: Medium
  - **Verification**: UI displays data from API, handles loading/error states

- **Developer 2:**
  - Create POST /api/channels/duo/initiate endpoint
  - Create POST /api/channels/group/create endpoint
  - Create POST /api/channels/group/join endpoint
  - Create GET /api/channels/my-channels endpoint
  - Create GET /api/channels/:channelId endpoint
  - Add validation middleware for all endpoints
  - Add error handling middleware
  - **Effort**: Large
  - **Verification**: All endpoints work correctly in Postman

**Day 6: Socket.io Backend Setup**
- **Lead Dev:**
  - Add socket_io_client package
  - Create SocketService class
  - Implement connection method with JWT
  - Create Riverpod provider for socket state
  - Add connection status indicator in UI
  - Test socket connection to backend
  - **Effort**: Medium
  - **Verification**: App connects to Socket.io server with JWT

- **Developer 2:**
  - Install and configure socket.io
  - Attach Socket.io to Express server
  - Implement JWT authentication middleware for sockets
  - Create room management logic (join, leave)
  - Implement basic events (join-channel, leave-channel)
  - Add logging for socket events
  - **Effort**: Large
  - **Verification**: Socket server accepts connections, rooms work correctly

**Day 7: WebRTC Signaling Events**
- **Lead Dev:**
  - Add flutter_webrtc package
  - Create WebRTCService class skeleton
  - Request microphone permissions
  - Create permission request UI
  - Test microphone access on devices
  - **Effort**: Medium
  - **Verification**: Microphone permission granted, can access audio

- **Developer 2:**
  - Implement Socket.io events for WebRTC signaling
  - Add offer/answer event handlers
  - Add ICE candidate event handlers
  - Implement start-speaking/stop-speaking events
  - Add presence notifications (user-joined, user-left)
  - Test signaling with Socket.io client tool
  - **Effort**: Large
  - **Verification**: Signaling events forwarded correctly between clients

### Week 2: Real-Time Communication (Days 8-14)

**Day 8: WebRTC Peer Connection Setup**
- **Lead Dev:**
  - Implement RTCPeerConnection creation
  - Configure ICE servers (STUN)
  - Set up event listeners (onIceCandidate, onTrack, onConnectionStateChange)
  - Create Riverpod provider for peer connections
  - Log connection state changes
  - **Effort**: Large
  - **Verification**: Peer connection created successfully

- **Developer 2:**
  - Research and select TURN server provider (Twilio recommended)
  - Sign up for TURN service
  - Create GET /api/turn/credentials endpoint
  - Implement temporary credential generation
  - Add TURN server documentation
  - **Effort**: Medium
  - **Verification**: Backend provides valid TURN credentials

**Day 9: Audio Capture & Streaming**
- **Lead Dev:**
  - Implement getUserMedia for audio capture
  - Add audio track to peer connection
  - Configure audio constraints (echo cancellation, noise suppression)
  - Create audio stream Riverpod provider
  - Test audio capture on device
  - **Effort**: Large
  - **Verification**: Can capture audio from microphone

- **Developer 2:**
  - Implement channel capacity checking
  - Add logic to prevent channel overflow
  - Create error responses for full channels
  - Add channel state persistence
  - Test concurrent connections
  - **Effort**: Medium
  - **Verification**: Backend enforces channel limits

**Day 10: WebRTC Offer/Answer**
- **Lead Dev:**
  - Implement createOffer method
  - Implement createAnswer method
  - Handle offer via Socket.io
  - Handle answer via Socket.io
  - Set local and remote descriptions
  - Test offer/answer exchange
  - **Effort**: Large
  - **Verification**: Offer and answer exchanged successfully

- **Developer 2:**
  - Add detailed logging for all socket events
  - Implement connection monitoring
  - Add metrics collection (active channels, users)
  - Create admin endpoint to view stats
  - **Effort**: Small
  - **Verification**: Backend logs provide debugging info

**Day 11: ICE Candidate Exchange**
- **Lead Dev:**
  - Implement onIceCandidate listener
  - Send ICE candidates via Socket.io
  - Handle incoming ICE candidates
  - Add ICE candidates to peer connection
  - Monitor ICE connection state
  - **Effort**: Medium
  - **Verification**: ICE candidates exchanged, connection established

- **Developer 2:**
  - Implement ICE candidate forwarding
  - Add validation for ICE messages
  - Handle ICE failure scenarios
  - Test with multiple clients
  - **Effort**: Medium
  - **Verification**: ICE candidates forwarded correctly

**Day 12: Audio Playback**
- **Lead Dev:**
  - Implement onTrack listener for remote audio
  - Set up audio playback for remote stream
  - Configure audio output settings
  - Test audio playback quality
  - Handle audio interruptions
  - **Effort**: Large
  - **Verification**: Can hear audio from remote peer

- **Developer 2:**
  - Optimize socket message payload size
  - Implement message compression (if needed)
  - Add rate limiting for socket events
  - Test under load
  - **Effort**: Small
  - **Verification**: Messages sent efficiently

**Day 13: End-to-End Audio Test**
- **Lead Dev:**
  - Test full audio flow with two devices
  - Debug any connection issues
  - Optimize audio quality settings
  - Test on different networks (WiFi, cellular)
  - Fix audio quality issues
  - **Effort**: Large
  - **Verification**: Clear audio transmission between two devices

- **Developer 2:**
  - Test backend with multiple concurrent channels
  - Monitor server performance
  - Optimize database queries
  - Add database connection pooling
  - **Effort**: Medium
  - **Verification**: Backend handles multiple channels efficiently

**Day 14: PTT Button Implementation**
- **Lead Dev:**
  - Create PTT button widget
  - Implement press-and-hold detection
  - Connect PTT to audio capture start/stop
  - Add visual feedback (button state changes)
  - Emit speaking events via Socket.io
  - Test PTT on devices
  - **Effort**: Large
  - **Verification**: PTT button controls audio transmission

- **Developer 2:**
  - Implement speaking state management
  - Broadcast speaking events to channel members
  - Add mutex to prevent multiple speakers
  - Test with group scenarios
  - **Effort**: Medium
  - **Verification**: Only one user can speak at a time

### Week 3: Notifications & Polish (Days 15-21)

**Day 15: Firebase Project Setup**
- **Lead Dev:**
  - Create Firebase project
  - Add Android app to Firebase
  - Download and add google-services.json
  - Add iOS app to Firebase
  - Download and add GoogleService-Info.plist
  - Configure Firebase in Flutter project
  - **Effort**: Medium
  - **Verification**: Firebase initialized in app

- **Developer 2:**
  - Create APNs key in Apple Developer portal
  - Upload APNs key to Firebase Console
  - Download Firebase service account JSON
  - Install firebase-admin in backend
  - Initialize Firebase Admin SDK
  - **Effort**: Medium
  - **Verification**: Backend can send FCM notifications

**Day 16: FCM Flutter Integration**
- **Lead Dev:**
  - Add firebase_messaging package
  - Configure Android (build.gradle, manifest)
  - Configure iOS (AppDelegate, Info.plist, capabilities)
  - Request notification permissions
  - Get FCM token on app start
  - Send token to backend (POST /api/users/device-token)
  - **Effort**: Large
  - **Verification**: FCM token obtained and sent to backend

- **Developer 2:**
  - Create device_tokens table
  - Create POST /api/users/device-token endpoint
  - Store FCM tokens in database
  - Handle token updates
  - Create notification send function
  - **Effort**: Medium
  - **Verification**: Device tokens stored in database

**Day 17: Notification Handlers**
- **Lead Dev:**
  - Implement FirebaseMessaging.onMessage (foreground)
  - Implement FirebaseMessaging.onBackgroundMessage
  - Implement getInitialMessage (terminated state)
  - Add flutter_local_notifications package
  - Create notification channels (Android)
  - Display local notifications
  - Handle notification taps
  - **Effort**: Large
  - **Verification**: Notifications received in all app states

- **Developer 2:**
  - Implement notification trigger logic
  - Send notification when user starts call and peer offline
  - Create notification payload format
  - Add priority flags for Android/iOS
  - Test notification sending
  - **Effort**: Large
  - **Verification**: Notifications sent when appropriate

**Day 18: Notification Navigation**
- **Lead Dev:**
  - Implement deep linking from notifications
  - Navigate to correct screen on notification tap
  - Pass channel data from notification
  - Auto-join channel when notification tapped
  - Test notification flow end-to-end
  - **Effort**: Medium
  - **Verification**: Tapping notification opens call screen

- **Developer 2:**
  - Add logging for notification delivery
  - Track notification success/failure rates
  - Handle FCM token refresh
  - Implement notification retry logic
  - **Effort**: Small
  - **Verification**: Notification delivery is reliable

**Day 19: Audio Visualizer**
- **Lead Dev:**
  - Research audio visualization options
  - Choose visualization approach (bars, waveform, custom)
  - Implement audio data extraction
  - Create custom painter for visualizer
  - Connect visualizer to audio stream
  - Add animations
  - **Effort**: Large
  - **Verification**: Visualizer animates with audio

- **Developer 2:**
  - Create call session logging
  - Create POST /api/sessions/start endpoint
  - Create PUT /api/sessions/:id/end endpoint
  - Store session metadata
  - **Effort**: Medium
  - **Verification**: Call sessions logged in database

**Day 20: UI Polish**
- **Lead Dev:**
  - Implement all screens (Dashboard, Duo, Group, Public, Call, Settings)
  - Apply consistent theming
  - Add loading states to all screens
  - Add error states with retry options
  - Implement smooth transitions
  - Add haptic feedback
  - **Effort**: Large
  - **Verification**: UI is complete and polished

- **Developer 2:**
  - Add API input validation
  - Improve error messages
  - Add request logging
  - Implement rate limiting
  - **Effort**: Medium
  - **Verification**: API is robust and well-protected

**Day 21: Background Audio Service**
- **Lead Dev:**
  - Add flutter_background_service package (Android)
  - Configure foreground service
  - Add required permissions to manifest
  - Configure iOS background audio mode
  - Create persistent notification
  - Keep WebRTC alive in background
  - Test background audio on both platforms
  - **Effort**: Large
  - **Verification**: Audio continues when app backgrounded

- **Developer 2:**
  - Optimize WebSocket reconnection logic
  - Add heartbeat mechanism
  - Handle server restarts gracefully
  - Test connection stability
  - **Effort**: Medium
  - **Verification**: Connections remain stable

### Week 4: Testing & Deployment (Days 22-30)

**Day 22: Connection Recovery**
- **Lead Dev:**
  - Implement automatic reconnection for Socket.io
  - Implement ICE restart for WebRTC failures
  - Handle network change events
  - Show connection status in UI
  - Test with poor network conditions
  - **Effort**: Large
  - **Verification**: App recovers from connection failures

- **Developer 2:**
  - Implement graceful shutdown handling
  - Add connection cleanup logic
  - Handle zombie connections
  - Test server restart scenarios
  - **Effort**: Medium
  - **Verification**: Server handles disconnections cleanly

**Day 23: Error Handling**
- **Lead Dev:**
  - Add comprehensive error handling
  - Show user-friendly error messages
  - Implement error reporting (Sentry or Firebase Crashlytics)
  - Test error scenarios
  - **Effort**: Medium
  - **Verification**: Errors handled gracefully

- **Developer 2:**
  - Add backend error logging (Winston or Pino)
  - Implement error monitoring
  - Add alerting for critical errors
  - Test error reporting
  - **Effort**: Small
  - **Verification**: Errors logged and monitored

**Day 24: Group Call Implementation**
- **Lead Dev:**
  - Extend WebRTC service for multiple peers
  - Manage multiple peer connections
  - Update UI for group calls
  - Test with 3-5 participants
  - **Effort**: Large
  - **Verification**: Group calls work with multiple users

- **Developer 2:**
  - Implement group room management
  - Handle multiple peer signaling
  - Broadcast to all group members
  - Test group scalability
  - **Effort**: Large
  - **Verification**: Backend handles group calls efficiently

**Day 25: Integration Testing**
- **Both Developers Together:**
  - Test complete auth flow (signup, login, logout)
  - Test duo call flow
  - Test group call flow
  - Test push notifications
  - Test background audio
  - Test on multiple devices
  - Test on different networks
  - Document bugs found
  - **Effort**: Large
  - **Verification**: Major flows work end-to-end

**Day 26: Bug Fixes**
- **Lead Dev:**
  - Fix critical bugs from testing
  - Optimize app performance
  - Reduce app size
  - Improve startup time
  - **Effort**: Large
  - **Verification**: Critical bugs resolved

- **Developer 2:**
  - Fix backend bugs
  - Optimize database queries
  - Add missing indexes
  - Improve API response times
  - **Effort**: Large
  - **Verification**: Backend performs well

**Day 27: Production Deployment**
- **Lead Dev:**
  - Create app icons and splash screens
  - Update version numbers
  - Configure release signing (Android keystore)
  - Build release APK/AAB
  - Test release build
  - **Effort**: Medium
  - **Verification**: Release build works correctly

- **Developer 2:**
  - Choose hosting provider (DigitalOcean, AWS, Heroku)
  - Set up production server
  - Configure production database
  - Set up SSL certificates
  - Deploy backend to production
  - Configure environment variables
  - Test production API
  - **Effort**: Large
  - **Verification**: Backend running in production

**Day 28: iOS Build & Submission Prep**
- **Lead Dev:**
  - Configure iOS certificates and provisioning profiles
  - Build iOS release archive
  - Test iOS release build
  - Prepare App Store screenshots
  - Write app description
  - **Effort**: Large
  - **Verification**: iOS build ready for submission

- **Developer 2:**
  - Set up monitoring (PM2, DataDog, New Relic)
  - Configure log aggregation
  - Set up automated backups
  - Create deployment documentation
  - **Effort**: Medium
  - **Verification**: Production monitoring in place

**Day 29: Documentation & Handoff**
- **Both Developers Together:**
  - Complete technical documentation
  - Write user guide
  - Create API documentation
  - Document deployment process
  - Create troubleshooting guide
  - **Effort**: Medium
  - **Verification**: Documentation complete

**Day 30: Final Testing & Buffer**
- **Both Developers Together:**
  - Perform final end-to-end testing
  - Test all features one last time
  - Verify production environment
  - Address any last-minute issues
  - Prepare for launch
  - **Effort**: Medium
  - **Verification**: App ready for store submission

### Task Count Summary
- **Total Tasks**: 60 tasks (30 days × 2 developers)
- **Lead Dev Tasks**: 30
- **Developer 2 Tasks**: 30
- **Joint Tasks**: 4 days

### Effort Distribution
- **Small Tasks**: 8 (1-3 hours)
- **Medium Tasks**: 32 (3-6 hours)
- **Large Tasks**: 20 (6-8 hours)
      `
    },
    {
      id: 'deployment',
      title: '12. App Store Deployment Guide',
      content: `
## Google Play Store Deployment

### Prerequisites Checklist
- [ ] Google Play Console account ($25 one-time fee)
- [ ] Signed release APK or AAB file
- [ ] App icons (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots (minimum 2, up to 8 per device type)
- [ ] Privacy policy URL
- [ ] App description (short and full)

### Step 1: Create Google Play Developer Account

1. Go to https://play.google.com/console
2. Click "Sign up" and follow the registration process
3. Pay the $25 one-time registration fee
4. Complete identity verification (may take 1-2 days)
5. Accept the Developer Distribution Agreement

### Step 2: Prepare Release Build

**Generate Upload Key:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Configure Signing (android/key.properties):**
```
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

**Build Release AAB:**
\`\`\`bash
flutter build appbundle --release
\`\`\`

File will be at: `build/app/outputs/bundle/release/app-release.aab`

### Step 3: Create App in Play Console

1. Click "Create app" in Play Console
2. Enter app details:
   - Name: "Walkie-Talkie"
   - Default language: English (United States)
   - App or game: App
   - Free or paid: Free
3. Declare if app is primarily for children: No
4. Accept declarations

### Step 4: Set Up App Content

**Store Listing:**
1. App name: "Walkie-Talkie" (max 50 characters)
2. Short description: (max 80 characters)
   "Real-time push-to-talk voice communication with friends and groups"
3. Full description: (max 4000 characters)
   Write compelling description highlighting:
   - Instant PTT communication
   - Duo and group calls
   - Secure authentication
   - Background audio support
4. App icon: Upload 512x512 PNG
5. Feature graphic: Upload 1024x500 PNG
6. Phone screenshots: Upload 2-8 images (1080x1920 recommended)
7. Tablet screenshots: Optional
8. Video: Optional YouTube link

**Categorization:**
1. App category: Communication
2. Tags: Add relevant tags
3. Email: Your support email
4. Privacy policy: URL to your privacy policy (required)

**App Access:**
1. Declare if app requires any special access or login
2. Provide demo credentials if login required for review

**Ads:**
1. Declare if app contains ads: No (or Yes if you add ads)

**Content Rating:**
1. Start questionnaire
2. Select app category: Communication
3. Answer all questions honestly
4. Complete questionnaire
5. Apply rating

**Target Audience:**
1. Select age groups: 13+ (due to voice communication)
2. Complete target audience declaration

**News Apps:**
1. If applicable: No

**COVID-19 Contact Tracing & Status Apps:**
1. If applicable: No

**Data Safety:**
1. Complete data safety form:
   - Does app collect user data? Yes
   - Location data: No
   - Personal info: Yes (name, email)
   - Audio files: Yes (voice data, not stored permanently)
2. Explain data usage and security practices
3. Declare data sharing with third parties
4. Link to privacy policy

**Government Apps:**
1. If applicable: No

### Step 5: Create Release

**Internal Testing Track (Recommended First):**
1. Go to Testing > Internal testing
2. Create new release
3. Upload AAB file
4. Add release name (e.g., "v1.0.0")
5. Add release notes
6. Add email addresses of testers
7. Review and rollout release

**Production Track (After Testing):**
1. Go to Production
2. Create new release
3. Upload AAB file
4. Complete release details
5. Rollout percentage: 100%
6. Review and start rollout

### Step 6: App Review Process

**Timeline:**
- Internal testing: Available immediately
- Production: 1-3 days (sometimes up to 7 days)

**Common Rejection Reasons:**
- Privacy policy missing or inadequate
- App crashes on startup
- Core functionality doesn't work
- Permissions not explained
- Content rating issues

### Step 7: Post-Launch

**Monitor:**
- Crashes and ANRs in Play Console
- User reviews and ratings
- Download statistics

**Update Process:**
1. Increment version in pubspec.yaml
2. Build new AAB
3. Create new release in Play Console
4. Upload and rollout

## Apple App Store Deployment

### Prerequisites Checklist
- [ ] Apple Developer Account ($99/year)
- [ ] macOS with Xcode installed
- [ ] Release iOS build (IPA file)
- [ ] App icons (1024x1024 PNG)
- [ ] Screenshots for all required device sizes
- [ ] Privacy policy URL
- [ ] App description

### Step 1: Create Apple Developer Account

1. Go to https://developer.apple.com
2. Click "Account" and sign in with Apple ID
3. Enroll in Apple Developer Program
4. Pay $99 annual fee
5. Complete identity verification (may take 1-2 days)
6. Accept agreements

### Step 2: Create App ID & Certificates

**Create App ID:**
1. Go to Certificates, Identifiers & Profiles
2. Click Identifiers > + (Add)
3. Select "App IDs" > Continue
4. Select "App" type
5. Description: "Walkie-Talkie"
6. Bundle ID: Explicit (e.g., com.yourcompany.walkietalkie)
7. Enable capabilities:
   - Push Notifications
   - Background Modes
8. Register

**Create Certificates:**
1. On Mac, open Keychain Access
2. Keychain Access > Certificate Assistant > Request Certificate from CA
3. Enter email and name, save to disk
4. In Developer Portal: Certificates > + (Add)
5. Select "iOS Distribution"
6. Upload CSR file
7. Download certificate
8. Double-click to install in Keychain

**Create Provisioning Profile:**
1. Profiles > + (Add)
2. Select "App Store" distribution
3. Select your App ID
4. Select distribution certificate
5. Name: "Walkie-Talkie Production"
6. Generate and download
7. Double-click to install

### Step 3: Configure Xcode

**Open Project:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner project
3. Select Runner target

**Signing & Capabilities:**
1. Signing: Automatically manage signing (or manual if preferred)
2. Team: Select your developer team
3. Bundle Identifier: Match App ID
4. Capabilities:
   - Enable "Push Notifications"
   - Enable "Background Modes" (Remote notifications, Audio)

**Build Settings:**
1. Set to "Release" configuration
2. Select "Any iOS Device" as destination
3. Archive the app: Product > Archive

**Upload APNs Key:**
1. Keys > + (Add key)
2. Name: "Walkie-Talkie APNs"
3. Enable Apple Push Notifications service
4. Register and download .p8 file
5. Note Key ID and Team ID
6. Upload to Firebase Console

### Step 4: Create App in App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Click "My Apps" > + (Add)
3. Select "New App"
4. Platform: iOS
5. Name: "Walkie-Talkie"
6. Primary Language: English (U.S.)
7. Bundle ID: Select the one you created
8. SKU: Unique identifier (e.g., walkietalkie001)
9. User Access: Full Access

### Step 5: Complete App Information

**App Information:**
1. Name: "Walkie-Talkie"
2. Subtitle: (max 30 chars) "Push-to-Talk Voice Calls"
3. Privacy Policy URL: Link to your privacy policy
4. Category: Primary (Social Networking or Utilities)
5. Content Rights: Check if you own all rights

**Pricing and Availability:**
1. Price: Free
2. Availability: All countries (or select specific)

**App Privacy:**
1. Click "Get Started"
2. Data Types Collected:
   - Contact Info: Email address
   - User Content: Audio data
   - Identifiers: User ID
3. For each data type:
   - Purpose: App functionality
   - Linked to user: Yes
   - Tracking: No
4. Save

### Step 6: Prepare Version for Release

**1.0 Version Information:**
1. Click "+ Version or Platform"
2. iOS
3. Version: 1.0

**Screenshots (Required for each device type):**

**iPhone 6.7" Display:**
- Size: 1290 x 2796 pixels
- Minimum: 1 image, Maximum: 10

**iPhone 6.5" Display:**
- Size: 1284 x 2778 pixels
- Minimum: 1 image, Maximum: 10

**iPhone 5.5" Display:**
- Size: 1242 x 2208 pixels
- Minimum: 1 image, Maximum: 10

**iPad Pro (6th Gen) 12.9":**
- Size: 2048 x 2732 pixels
- Minimum: 1 image, Maximum: 10

**Promotional Text:** (max 170 chars)
"Experience real-time voice communication with push-to-talk. Connect instantly with friends or join group conversations."

**Description:** (max 4000 chars)
Write detailed description covering:
- Key features
- How it works
- Benefits
- Usage scenarios

**Keywords:** (max 100 chars)
"walkie talkie,push to talk,ptt,voice chat,group call,instant communication"

**Support URL:** Your support website

**Marketing URL:** Optional

**App Icon:**
- Upload 1024x1024 PNG (no transparency, no alpha channel)

### Step 7: Upload Build

**From Xcode:**
1. After archiving, Organizer window opens
2. Select your archive
3. Click "Distribute App"
4. Select "App Store Connect"
5. Select "Upload"
6. Select distribution certificate and profile
7. Upload
8. Wait for processing (5-30 minutes)

**In App Store Connect:**
1. Refresh the page after processing completes
2. Under Build section, click "+ Build"
3. Select the uploaded build
4. Save

### Step 8: Submit for Review

**Age Rating:**
1. Complete questionnaire
2. Set appropriate age rating (likely 12+ due to user interaction)

**App Review Information:**
1. Contact information (first name, last name, phone, email)
2. Demo account credentials (if login required)
3. Notes: Explain PTT functionality and how to test

**Version Release:**
1. Select "Automatically release this version"
   - Or "Manually release this version" if you want control

**Submit for Review:**
1. Review all information
2. Click "Submit for Review"

### Step 9: App Review Process

**Timeline:**
- First submission: 2-7 days
- Updates: 1-3 days
- Expedited review: Available for critical issues

**Review Status:**
- Waiting for Review
- In Review
- Pending Developer Release (if manual release)
- Ready for Sale

**Common Rejection Reasons:**
- App crashes on launch
- Missing privacy policy
- Features don't work as described
- Permissions not explained
- Background audio not working
- Push notifications don't work

**If Rejected:**
1. Read rejection message carefully
2. Fix issues
3. Build new version or respond to reviewer
4. Resubmit

### Step 10: Post-Launch

**Monitor:**
- Crash reports in App Store Connect
- User reviews
- Download statistics
- Revenue (if paid)

**Update Process:**
1. Increment version number
2. Build and archive in Xcode
3. Upload new build
4. Create new version in App Store Connect
5. Fill in "What's New" section
6. Submit for review

## Post-Deployment Checklist

**Both Stores:**
- [ ] Monitor crash reports daily
- [ ] Respond to user reviews
- [ ] Track key metrics (downloads, DAU, retention)
- [ ] Collect user feedback
- [ ] Plan update schedule (monthly recommended)
- [ ] Monitor backend performance
- [ ] Check notification delivery rates
- [ ] Review WebRTC connection success rates

**Marketing:**
- [ ] Create landing page
- [ ] Share on social media
- [ ] Submit to app directories
- [ ] Create demo videos
- [ ] Reach out to tech bloggers
- [ ] Consider paid advertising

**Analytics:**
- [ ] Set up Firebase Analytics or Mixpanel
- [ ] Track key user flows
- [ ] Monitor conversion rates
- [ ] A/B test features

**Support:**
- [ ] Set up support email/ticketing system
- [ ] Create FAQ documentation
- [ ] Monitor app store reviews for issues
- [ ] Provide timely responses

## Common Deployment Issues

**Issue: Build Fails**
- Solution: Check Xcode/Android Studio logs, verify signing configuration

**Issue: App Rejected for Privacy**
- Solution: Ensure comprehensive privacy policy, explain data usage clearly

**Issue: Crash on Launch in Review**
- Solution: Test release builds thoroughly, check for missing API keys

**Issue: Background Audio Not Working for Reviewers**
- Solution: Provide detailed testing instructions, include demo account

**Issue: Push Notifications Not Working**
- Solution: Verify FCM/APNs configuration, test on multiple devices

**Issue: Large App Size**
- Solution: Enable app bundles (Android), optimize assets, use vector graphics
      `
    }
  ];

  const sections3 = [
    {
      id: 'ios-specific',
      title: '13. iOS-Specific Implementation Guide',
      content: `
## iOS Platform-Specific Features

This section covers iOS-specific implementations, configurations, and best practices that differ from Android.

### iOS Project Configuration

**Info.plist Required Keys:**

\`\`\`xml
<!-- Microphone Permission -->
<key>NSMicrophoneUsageDescription</key>
<string>Walkie-Talkie needs microphone access for voice communication</string>

<!-- Background Modes -->
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>remote-notification</string>
    <string>fetch</string>
    <string>processing</string>
</array>

<!-- URL Schemes for Auth0 -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>None</string>
        <key>CFBundleURLName</key>
        <string>auth0</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.yourcompany.walkietalkie</string>
        </array>
    </dict>
</array>

<!-- Firebase Configuration -->
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
\`\`\`

### iOS Audio Session Configuration

**AVAudioSession Setup:**

iOS requires explicit audio session configuration for:
- Recording and playback simultaneously
- Background audio
- Bluetooth audio routing
- Handling interruptions

**Configuration Steps:**

1. **Import AVFoundation** in AppDelegate.swift
2. **Set audio session category** to `.playAndRecord`
3. **Set mode** to `.voiceChat` for optimized voice quality
4. **Enable options**: 
   - `.allowBluetooth` for Bluetooth headsets
   - `.defaultToSpeaker` for speaker output
   - `.mixWithOthers` if needed

**Sample AppDelegate Configuration:**

\`\`\`swift
import UIKit
import Flutter
import AVFoundation
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Configure Firebase
    FirebaseApp.configure()
    
    // Configure Audio Session
    configureAudioSession()
    
    // Configure Notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func configureAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(
        .playAndRecord,
        mode: .voiceChat,
        options: [.allowBluetooth, .defaultToSpeaker]
      )
      try audioSession.setActive(true)
    } catch {
      print("Failed to configure audio session: \\(error)")
    }
  }
  
  // Handle audio interruptions (phone calls, Siri, etc.)
  override func applicationWillResignActive(_ application: UIApplication) {
    NotificationCenter.default.post(name: NSNotification.Name("AudioInterruption"), object: nil)
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    // Reactivate audio session if needed
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to reactivate audio session: \\(error)")
    }
  }
}
\`\`\`

### iOS Background Execution

**Background Modes Configuration:**

1. **In Xcode**: Select Runner target → Signing & Capabilities
2. **Add Capability**: Background Modes
3. **Enable**:
   - Audio, AirPlay, and Picture in Picture
   - Remote notifications
   - Background fetch
   - Background processing

**Background Audio Best Practices:**

- Keep audio session active during calls
- Handle audio route changes (headphones plugged/unplugged)
- Properly clean up when call ends
- Monitor battery usage

**Handling Audio Interruptions:**

In Flutter, listen for interruptions:

\`\`\`
// In Flutter code
void setupInterruptionListener() {
  // Listen to app lifecycle changes
  WidgetsBinding.instance.addObserver(this);
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.paused) {
    // Call interrupted (phone call, etc.)
    // Pause audio streaming
  } else if (state == AppLifecycleState.resumed) {
    // Resume audio streaming
  }
}
\`\`\`

### iOS Push Notifications (APNs)

**APNs vs FCM on iOS:**

On iOS, Firebase uses APNs as the underlying delivery mechanism:
1. Your backend sends to FCM
2. FCM forwards to APNs
3. APNs delivers to iOS device

**Silent Push Notifications:**

For background wakeup when receiving calls:

\`\`\`json
{
  "aps": {
    "content-available": 1,
    "sound": ""
  },
  "data": {
    "type": "incoming_call",
    "channelId": "channel_123"
  }
}
\`\`\`

**VoIP Push Notifications (Advanced):**

For true VoIP-style calling:

1. **Enable PushKit**:
   - Add Push Notifications capability in Xcode
   - Import PushKit framework
   - Register for VoIP notifications

2. **Handle VoIP Push**:
   - Wakes app even when terminated
   - Must show CallKit UI within seconds
   - Required for App Store approval if using "call" terminology

3. **Integration Complexity**: High
   - Requires native iOS code
   - CallKit integration mandatory
   - No simple Flutter plugin (as of 2025)

**Recommendation**: For MVP, use standard remote notifications. VoIP push is overkill unless you need instant wakeup for terminated apps.

### iOS Permissions

**Request Permissions Early:**

Unlike Android, iOS shows permission dialogs immediately on first request. Plan the flow carefully.

**Microphone Permission:**

\`\`\`dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestMicrophonePermission() async {
  final status = await Permission.microphone.request();
  
  if (status.isDenied) {
    // Show explanation dialog
    showDialog(/* ... */);
  } else if (status.isPermanentlyDenied) {
    // Direct user to settings
    openAppSettings();
  }
  
  return status.isGranted;
}
\`\`\`

**Notification Permission:**

\`\`\`dart
Future<void> requestNotificationPermission() async {
  final messaging = FirebaseMessaging.instance;
  
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  }
}
\`\`\`

### iOS WebRTC Considerations

**ATS (App Transport Security):**

If connecting to local/development servers:

\`\`\`xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <!-- Better: specify exception domains -->
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
\`\`\`

**Camera/Microphone Usage on iOS:**

- First request shows system dialog
- User can deny at any time in Settings
- App must handle denied state gracefully
- Explain why you need permissions before requesting

**iOS WebRTC Audio Quality:**

Configure audio constraints for iOS:

\`\`\`dart
final mediaConstraints = {
  'audio': {
    'echoCancellation': true,
    'noiseSuppression': true,
    'autoGainControl': true,
    'googEchoCancellation': true,
    'googNoiseSuppression': true,
    'googAutoGainControl': true,
  }
};
\`\`\`

### iOS Widget Implementation (Limited)

**iOS Widgets vs Android:**

- iOS widgets are **read-only** (cannot have interactive buttons)
- Built with SwiftUI/WidgetKit
- Can only open app with deep link
- Update via timeline provider

**Basic Implementation:**

1. **Add Widget Extension** in Xcode
2. **Create Widget Provider**
3. **Use App Groups** for data sharing
4. **Update from Flutter** using home_widget package

**Limitations:**
- No PTT button in widget (iOS doesn't allow)
- Can show last channel/status
- Tapping opens app

### iOS-Specific UI Considerations

**Safe Area Insets:**

iOS has notch/Dynamic Island:

\`\`\`dart
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: YourContent(),
    ),
  );
}
\`\`\`

**iOS Design Guidelines:**

- Use iOS-style navigation (back button placement)
- Respect iOS haptic feedback patterns
- Use Cupertino widgets where appropriate
- Follow HIG (Human Interface Guidelines)

**Platform-Specific UI:**

\`\`\`dart
if (Platform.isIOS) {
  return CupertinoButton(/* ... */);
} else {
  return ElevatedButton(/* ... */);
}
\`\`\`

### iOS Build & Deployment

**Xcode Build Settings:**

1. **Deployment Target**: iOS 12.0 minimum
2. **Swift Language Version**: Swift 5
3. **Architectures**: arm64 (required), armv7 (optional for older devices)
4. **Bitcode**: Disabled (Flutter doesn't support)

**Code Signing:**

1. **Development**: Automatic signing OK
2. **Production**: Use Distribution certificate and provisioning profile
3. **Archive**: Product → Archive in Xcode
4. **Export**: Use "App Store Connect" option

**Common iOS Build Issues:**

- **Signing errors**: Ensure certificates valid and profiles match Bundle ID
- **Missing frameworks**: Check Podfile, run `pod install`
- **Bitcode error**: Disable bitcode in build settings
- **Module not found**: Clean build folder, reinstall pods

### iOS-Specific Testing

**Test on Real Devices:**

Simulators have limitations:
- No microphone/camera access
- Push notifications don't work
- Background audio behaves differently
- WebRTC may not work properly

**Test Scenarios:**

1. Incoming phone call during voice chat
2. Siri invocation during call
3. Switching audio output (speaker, Bluetooth, headphones)
4. App backgrounding/foregrounding
5. Device lock/unlock during call
6. Low battery mode effects
7. Network switching (WiFi to cellular)

### iOS Performance Optimization

**Memory Management:**

- iOS is stricter about memory than Android
- Monitor memory usage in Xcode Instruments
- Dispose WebRTC connections properly
- Release audio resources when not needed

**Battery Usage:**

- Background audio drains battery
- Monitor energy impact in Xcode
- Optimize WebRTC bitrate
- Use efficient codecs (Opus)

**Network Optimization:**

- iOS aggressively manages background network
- Use Network Extension framework for monitoring
- Handle network transitions smoothly

### iOS App Store Review Specific

**Common iOS Rejections:**

1. **Background audio not working**: Test thoroughly before submission
2. **Permissions not explained**: Ensure usage descriptions are clear
3. **Push notifications don't work**: Verify APNs configuration
4. **App crashes on iOS version reviewer uses**: Test on multiple iOS versions
5. **Missing features described**: Ensure all advertised features work

**Reviewer Testing Tips:**

- Provide test account with clear instructions
- Explain PTT functionality clearly
- Note that two accounts needed to test
- Mention background audio should continue when locked

### iOS-Specific Troubleshooting

**Audio Not Working:**
- Check AVAudioSession configuration
- Verify Info.plist has microphone description
- Ensure audio session activated
- Check for interruptions handling

**Background Doesn't Work:**
- Verify background modes enabled
- Check audio session category
- Ensure app doesn't get suspended
- Monitor console logs for suspension reasons

**Push Notifications Don't Arrive:**
- Verify APNs key uploaded to Firebase
- Check Bundle ID matches everywhere
- Ensure device token sent to backend
- Test with Apple's Push Notification Console

**WebRTC Connection Fails:**
- Check STUN/TURN configuration
- Verify network permissions
- Test on cellular and WiFi separately
- Check for VPN/firewall interference
      `
    },
    {
      id: 'appendix',
      title: '14. Appendices & References',
      content: `