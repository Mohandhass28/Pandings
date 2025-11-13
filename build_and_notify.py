import subprocess
import os
import pywhatkit
import time
from datetime import datetime, timedelta
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

# 1️⃣ Configurations
PROJECT_PATH = r"D:/App/kanagamaniApp/pendings"
APK_PATH = r"D:/App/kanagamaniApp/pendings/build/app/outputs/flutter-apk/app-release.apk"
WHATSAPP_NUMBER = "+919345727810"
FLUTTER_CMD = r'C:\Flutter\src\flutter\bin\flutter.bat'

# Push code to GitHub before build

# WANT_TO_PUSH = False
WANT_TO_PUSH = True

try:
    if WANT_TO_PUSH:
        subprocess.run(["git", "add", "."], cwd=PROJECT_PATH, check=True)
        subprocess.run(["git", "commit", "-m", "Automated commit before APK build"], cwd=PROJECT_PATH, check=True)
        subprocess.run(["git", "push"], cwd=PROJECT_PATH, check=True)
        print("✅ Code pushed to GitHub successfully!")
except subprocess.CalledProcessError as git_error:
    print(f"⚠️ Error pushing to GitHub: {git_error}")

try:
    subprocess.run(
        [FLUTTER_CMD, "build", "apk", "--release"],
        cwd=PROJECT_PATH,
        check=True,
    )
    print("✅ Flutter build completed.")
except subprocess.CalledProcessError as e:
    print("❌ Flutter build failed:", e)
    exit(1)

# === STEP 2: CHECK APK EXISTS ===
if not os.path.exists(APK_PATH):
    print("❌ APK file not found! Check your Flutter build output path.")
    exit(1)

print("📤 Preparing to send APK via WhatsApp...")

# === STEP 3: SETUP SELENIUM CHROME DRIVER ===
options = Options()
options.add_argument("--user-data-dir=C:\\Users\\Dhass\\chrome_profile")  # keeps login session
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--disable-gpu")
options.add_argument("--disable-extensions")
options.add_argument("--disable-plugins")

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

try:
    driver.get("https://web.whatsapp.com/")
    print("📱 Waiting for WhatsApp Web to load...")

    # Wait for WhatsApp Web chat search bar to load
    WebDriverWait(driver, 60).until(
        EC.presence_of_element_located((By.XPATH, "//div[@contenteditable='true'][@data-tab='3']"))
    )

    # Search for the contact and press enter to open chat
    search_box = driver.find_element(By.XPATH, "//div[@contenteditable='true'][@data-tab='3']")
    search_box.send_keys(WHATSAPP_NUMBER)
    time.sleep(2)
    search_box.send_keys(Keys.ENTER)

    print("💬 Chat opened successfully.")
    time.sleep(5)

    # Wait for message input
    WebDriverWait(driver, 20).until(
        EC.presence_of_element_located((By.XPATH, "//div[@role='textbox']"))
    )

    # === STEP 4: ATTACH AND SEND APK ===

    apk_uploaded = False
    try:
        # Focus the message input
        message_input = driver.find_element(By.XPATH, "//div[@role='textbox']")
        message_input.click()
        time.sleep(1)

        attach_button = driver.find_element(By.XPATH, '//*[@id="main"]/footer/div[1]/div/span/div/div[2]/div/div[1]/button')
        attach_button.click()
        time.sleep(2)

        # Select file input and send file path
        file_input = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((By.XPATH, "//input[@type='file']"))
        )
        file_input.send_keys(APK_PATH)
        print("📂 APK file attached.")
        time.sleep(5)  # Wait for file to load

        # Wait for send button to appear and click
        send_button = WebDriverWait(driver, 30).until(
            EC.element_to_be_clickable((By.XPATH, '//*[@id="app"]/div[1]/div/div[3]/div/div[3]/div[2]/div/span/div/div/div/div[2]/div/div[2]/div[2]/div/div/span'))
        )
        send_button.click()

        print("✅ APK sent successfully!")
        apk_uploaded = True
        time.sleep(40)

    except Exception as attach_error:
        print(f"⚠️ Error during attach/send: {type(attach_error).__name__}: {attach_error}")
        raise

except Exception as e:
    print("⚠️ Error while sending APK:", e)
finally:
    if apk_uploaded:
        driver.quit()
        print("🧹 Browser closed. Process complete.")
    else:
        print("⚠️ APK not uploaded. Browser remains open for manual action.")
