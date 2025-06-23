from ultralytics import YOLO

def main():
    print("Hello, world!")
    model = YOLO("yolov8n.pt")  # Example usage
    print("Model loaded:", model)

if __name__ == "__main__":
    main()
