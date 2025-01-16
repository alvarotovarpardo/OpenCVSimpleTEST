#include <opencv2/opencv.hpp>

int main() {
    // Load an image from file
    cv::Mat image = cv::imread("example.jpg");
    
    if (image.empty()) {
        std::cerr << "Error: Could not load the image!" << std::endl;
        return -1;
    }
    
    // Display the image in a window
    cv::imshow("Simple OpenCV Program", image);
    
    // Wait for a key press indefinitely
    cv::waitKey(0);
    
    return 0;
}