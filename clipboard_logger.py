# clipboard_logger.py
import time
import pyperclip
from datetime import datetime

clipboard_cache = ""

def get_clipboard():
    try:
        return pyperclip.paste()
    except:
        return ""

def save_to_file(content):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open("/tmp/copy.txt", "a") as f:
        f.write(f"[{timestamp}] {content}\n")

while True:
    current = get_clipboard()
    if current != clipboard_cache and current.strip():
        clipboard_cache = current
        save_to_file(current)
    time.sleep(1)
