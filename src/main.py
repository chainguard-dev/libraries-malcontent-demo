try:
    import ultralytics
except ImportError:
    ultralytics = None
    print("Warning: 'ultralytics' package not found. Proceeding without it.")

def main():
    if ultralytics:
        version = getattr(ultralytics, '__version__', 'unknown')
        print(f"Loaded ultralytics version: {version}")
    else:
        print("Ultralytics is not available.")

if __name__ == "__main__":
    main()
