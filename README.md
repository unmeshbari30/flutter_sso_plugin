# flutter\_sso\_plugin

`` is a Flutter plugin that enables seamless Single Sign-On (SSO) by securely storing user credentials using Android's **AccountManager** and iOS's **Keychain with Shared App Group**. This plugin helps persist authentication data and enables cross-app login within the same organization.

---

## ✨ Features

- 🔐 Securely save login credentials.
- 🚀 Retrieve credentials at app launch to persist sessions.
- 🧹 Easily remove credentials on logout.
- 📱 Supports both Android and iOS with platform-specific best practices.

---

## 📦 Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_sso_plugin: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 🧑‍💻 Usage

### 1. Save SSO Credentials

Store user credentials securely after successful login.

```dart
await FlutterSsoPlugin.saveAccount(
  username: "admin",
  accessToken: "abc123",
  refreshToken: "xyz789",
  profileJson: '{"role":"admin","email":"john@example.com"}',
);
```

### 2. Retrieve Credentials

This is typically done during app launch to check if a user is already logged in.

```dart
FlutterSsoPlugin.configure(keychainGroup: "YOUR.TEAM.ID.SHARED"); // iOS only

final account = await FlutterSsoPlugin.getAccount();

if (account != null) {
  final username = account["username"];
  final accessToken = account["accessToken"];
  final profile = account["profile"];
  // Proceed to home screen
}
```

### 3. Remove Credentials (Logout)

```dart
final success = await FlutterSsoPlugin.removeAccount();
if (success) {
  // Navigate to login screen
}
```

---

## 📱 Platform Setup

### 🟢 Android

No special configuration is required for Android. The plugin uses Android's `AccountManager` under the hood.

---

### 🍏 iOS

To share credentials between multiple iOS apps under the same organization:

1. Open your project in **Xcode**.

2. Go to **Signing & Capabilities** tab.

3. Enable **Keychain Sharing**.

4. Add a shared **Keychain Group**, for example:

   ```
   YOUR.TEAM.ID.SHARED
   ```

5. Use the same keychain group string when initializing the plugin:

   ```dart
   FlutterSsoPlugin.configure(keychainGroup: "YOUR.TEAM.ID.SHARED");
   ```

6. Make sure all apps using this plugin include the same group.

---

## 💡 Full Example

### Login Screen

```dart
ElevatedButton(
  onPressed: () async {
    if (usernameController.text == "admin" && passwordController.text == "password") {
      await FlutterSsoPlugin.saveAccount(
        username: "admin",
        accessToken: "abc123",
        refreshToken: "xyz789",
        profileJson: '{"role":"admin","email":"admin@example.com"}',
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen(title: "Plugin Testing")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials")),
      );
    }
  },
  child: const Text("Login"),
);
```

### App Initialization

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSsoPlugin.configure(keychainGroup: "YOUR.TEAM.ID.SHARED"); // iOS only
  runApp(MyApp());
}
```

```dart
FutureBuilder<bool>(
  future: checkIfUserLoggedIn(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const CircularProgressIndicator();
    return snapshot.data! ? const HomeScreen(title: "Hey") : const LoginScreen();
  },
)
```

### Logout Handler

```dart
final success = await FlutterSsoPlugin.removeAccount();
if (success) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
}
```

---

## 📌 Notes

- `profileJson` is a custom JSON string to store additional user data like email or roles.
- Always initialize the plugin early using `FlutterSsoPlugin.configure()` before any credential actions.
- If using this plugin across multiple iOS apps, ensure the **Keychain Group** matches in all apps.

---

## 🛠️ API Reference

| Method                       | Description                         |
| ---------------------------- | ----------------------------------- |
| `configure({keychainGroup})` | iOS only: Set shared keychain group |
| `saveAccount({...})`         | Store user credentials securely     |
| `getAccount()`               | Retrieve stored credentials         |
| `removeAccount()`            | Delete stored credentials           |

---

## 🧑‍🏫 Who is this for?

This plugin is ideal for:

- Organizations with **multiple Flutter apps** needing shared authentication.
- Apps needing **session persistence** after relaunch.
- Developers wanting an easy and secure way to manage user sessions.

---

## 📃 License

MIT License. See [`LICENSE`](LICENSE) for details.

