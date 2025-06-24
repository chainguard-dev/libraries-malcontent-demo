import ultralytics

def main():
    print(f"Loaded ultralytics version: {getattr(ultralytics, '__version__', 'unknown')}")

if __name__ == "__main__":
    main()
