import subprocess
import os
import pywhatkit
import time
from datetime import datetime, timedelta

# 1️⃣ Configurations
PROJECT_PATH = r"D:/App/kanagamaniApp/pendings"  
APK_PATH = os.path.join(PROJECT_PATH, "build\\app\\outputs\\flutter-apk\\app-release.apk")
WHATSAPP_NUMBER = "+919345727810"  
FLUTTER_CMD = r'C:\Flutter\src\flutter\bin\flutter.bat'  

print("🚀 Building Flutter APK...")
# subprocess.run([FLUTTER_CMD, "build", "apk", "--release"], cwd=PROJECT_PATH, check=True)

push = input("Do you want to push to GitHub? (y/n): ").strip().lower()
if push == "y":
    subprocess.run(["git", "add", "."], cwd=PROJECT_PATH)
    subprocess.run(["git", "commit", "-m", "auto build"], cwd=PROJECT_PATH)
    subprocess.run(["git", "push"], cwd=PROJECT_PATH)
    print("✅ Code pushed to GitHub.")
else:
    print("❎ Skipped GitHub push.")

# 4️⃣ Send APK via WhatsApp
if os.path.exists(APK_PATH):
    print("📤 Sending APK via WhatsApp...")
    now = datetime.now() + timedelta(minutes=1)  # schedule 1 minute from now
    pywhatkit.sendwhats_image(
        phone_no=WHATSAPP_NUMBER,
        img_path=APK_PATH,
        caption="📱 Here’s the latest Flutter app build (APK)!",
        wait_time=15,
        tab_close=True
    )
    print("✅ APK sent successfully!")
else:
    print("❌ APK file not found! Check your Flutter build output path.")


