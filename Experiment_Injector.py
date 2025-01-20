import ctypes
import psutil
import pymem
import time
import win32api
import win32con
import win32process

# Function to get the process ID of RobloxPlayerBeta
def get_pid(process_name):
    for proc in psutil.process_iter(['pid', 'name']):
        if process_name.lower() in proc.info['name'].lower():
            return proc.info['pid']
    return None

# Function to inject the DLL into RobloxPlayerBeta
def inject_dll(process_name, dll_path):
    pid = get_pid(process_name)
    if pid is None:
        print(f"Could not find process: {process_name}")
        return
    
    # Open the target process with pymem
    pm = pymem.Pymem(process_name)
    
    # Allocate memory for the DLL path
    dll_path_buffer = ctypes.create_unicode_buffer(dll_path)
    remote_memory = pm.allocate(len(dll_path_buffer))
    
    # Write the DLL path to the allocated memory
    pm.write_bytes(remote_memory, dll_path_buffer.raw)
    
    # Get the address of LoadLibraryW from kernel32.dll
    kernel32 = win32api.GetModuleHandle('kernel32.dll')
    load_library = win32api.GetProcAddress(kernel32, 'LoadLibraryW')
    
    # Create a remote thread to call LoadLibraryW with the DLL path
    thread_id = win32process.CreateRemoteThread(pm.process_handle, None, 0, load_library, remote_memory, 0, None)
    
    # Wait for the thread to finish
    time.sleep(2)
    
    print(f"DLL Injected into process: {process_name}")

# Path to the DLL
dll_path = r"C:\Users\aural\OneDrive\Desktop\Stuff\Injector.dll"
inject_dll("RobloxPlayerBeta.exe", dll_path)
