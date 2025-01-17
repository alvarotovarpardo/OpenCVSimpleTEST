#include <string>
#include <filesystem>
#include <iostream>
#include <regex>
#include <opencv2/opencv.hpp>
#include <fstream>
#include <mutex>

#if defined(_WIN32)
#include <windows.h>
#else
#include <unistd.h>
#endif

std::string executableDir() {
    char buffer[1024];
    
#if defined(_WIN32)
    GetModuleFileNameA(nullptr, buffer, sizeof(buffer));
#else
    readlink("/proc/self/exe", buffer, sizeof(buffer));
#endif

    return std::filesystem::path(buffer).parent_path().string();
}

std::string getDirNuc(std::string sPathCalibration, int iNuc){
    if(sPathCalibration == "") sPathCalibration = "C:/Legumbres";
    std::filesystem::path dirCalibration = sPathCalibration;
    
    if (!std::filesystem::exists(dirCalibration)) 
    {
        std::filesystem::create_directories(dirCalibration);
    }

    std::filesystem::path dirNuc = dirCalibration / std::to_string(iNuc);

    if (!std::filesystem::exists(dirNuc)) 
    {
        std::filesystem::create_directory(dirNuc);
    }
    
    return dirNuc.string();
}

void initOffset()
{
    std::cout << "Inicializando Offset... \n";
}


void initGain()
{
    std::cout << "Inicializando Gain... \n";
}


std::vector<std::string> findFiles(const std::string& nucPath, const std::regex& regex) {
    std::vector<std::string> foundFiles;
    for (const auto& entry : std::filesystem::directory_iterator(nucPath)) {
        if (std::regex_search(entry.path().filename().string(), regex)) {
            foundFiles.push_back(entry.path().string());
        }
    }
    return foundFiles;
}

bool readNucMat(std::string filePath, cv::Mat &mat, int size)
{
    std::ifstream file(filePath, std::ios::binary);
    int _height = 512;
    int _width = 640;

    if(file.is_open())
    {
        std::filesystem::path pathToRaw(filePath);
        int tint = std::stoi(pathToRaw.parent_path().filename().string()); // Guardamos tint de la carpeta (para check)
        int bytesToRead = _height * _width * size; // Bytes a ser leidos
        file.read(reinterpret_cast<char *> (mat.data), bytesToRead); // Leemos
        int bytesRead = file.gcount(); // Bytes leidos

        // Check
        if (bytesRead > 0)
        {
            std::cout << "SENSIANuc::readNucMat. \n Matrix read - " << filePath << "\nWith tint - " << tint << "\nRows/Columns - " << mat.rows << "/" << mat.cols << std::endl;
        }
        else
        {
            std::cout <<"SENSIANuc::readNucMat - no matrix read.\n";
        }

        file.close();
        if (bytesToRead == bytesRead)
        {
            std::cout << "Bytes read = Bytes to read\n";
            return true;
        }
        else
        {
            std::cout << "Bytes read != Bytes to read\nBytes read: " << bytesRead << "\nBytes to read: " << bytesToRead << std::endl; 
        }
        
    }
    else
    {
        return false;
    }
}

void setGainForcingNucValue(int iValue)
{
    // TEST: Inicializamos Offset aquí para imaginar que ya viene dado
    cv::Mat Gain = cv::Mat::ones(512, 640, CV_32F);
    std::string m_sPathNucStd = "C:/CODE2/Tests/Calibration/01/Nucs";
    int _width = 640; 
    int _height = 512;

    std::regex regex("GainU.*.raw", std::regex_constants::icase);
    std::string filePath = m_sPathNucStd + "/" + std::to_string(iValue);

    auto rawFiles = findFiles(filePath, regex);

    if (rawFiles.empty())
    {
        initGain();
        throw std::ios_base::failure("GainU.raw not found.");
        return;
    }

    std::string GainPath = rawFiles[0];

    if(!readNucMat(GainPath, Gain, 4))
    {   
        throw std::ios_base::failure("Could not read GainU.raw file.");
        initGain();
    }
}


void setOffsetForcingNucValue(int iValue)
{
    // TEST: Inicializamos Offset aquí para imaginar que ya viene dado
    cv::Mat Offset = cv::Mat::zeros(512, 640, CV_32F);
    std::string m_sPathNucStd = "C:/CODE2/Tests/Calibration/01/Nucs";
    int _width = 640; 
    int _height = 512;

    std::regex regex("OffsetU.*.raw", std::regex_constants::icase);
    std::string filePath = m_sPathNucStd + "/" + std::to_string(iValue);
    auto rawFiles = findFiles(filePath, regex);

    if(rawFiles.empty()){
        initOffset();
        return;
    }
    std::string offsetFile (rawFiles.at(0));
    uint bands = (uint) offsetFile.size()/(_width*_height*4);
    //std::string filePath {rawFiles.at(0).toStdString()};
    if(bands > 1){
        std::cout << "Implement readOffsetFileBands!\n";
        // if(!readOffsetFileBands(filePath, bands, bolometerValue)){
        //     initOffset();
        // }
    }
    else if(!readNucMat(offsetFile,Offset,4))
    {
        initOffset();
    }
}



int main() {
    int tint = 210;
    
    // TEST 1:
    // Compruebo que la función executableDir() devuelve la ruta del ejecutable
    // Compruebo si devuelve automáticamente un string o si tengo que convertirlo
    std::cout << "---- PRUEBA 1 -----:\n\n\n ";
    std::cout << "----- current_path(): ";
    auto path = std::filesystem::current_path();
    std::cout << path << std::endl;
    std::cout << "Es un std::string: " << std::is_same<decltype(path), std::string>::value << std::endl;
    auto string_path = path.string();
    std::cout << "Llamo a .string()... \n" << std::endl;
    std::cout << "Es un std::string: " << std::is_same<decltype(string_path), std::string>::value << std::endl;
    

    // TEST 2
    // Compruebo que la función executableDir() devuelve la ruta del ejecutable, a diferencia de current_path()
    std::cout << "\n\n\n---- PRUEBA 2 -----:\n ";
    std::cout << "---- executable_path(): ";
    std::cout << executableDir() << std::endl;
    
    
    // TEST 3
    // Compruebo que getDirNuc está bien escrito y me crea un path 
    // en la carpeta C:/Legumbres con el tint especificado si el argumento de entrada está vacío
    std::cout << "\n\n\n---- PRUEBA 3 -----:\n ";
    auto myPath = "";
    std::cout << getDirNuc(myPath, 968) << std::endl; // Creates the path 

    
    // TEST 4
    // Busco un GainU.raw que existe y devuelvo el path. Compruebo el tipo.
    std::string nucPath = "C:/CODE2/Tests/Calibration/01/Nucs";
    std::cout << "\n\n\n---- PRUEBA 4 -----:\n";
    try
    {
        setGainForcingNucValue(tint);
    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << '\n';
    }
    
    
    // TEST 5 
    // Leemos matriz y la cargamos
    std::string filePath = nucPath + "//210//GainU.raw";
    cv::Mat mat = cv::Mat::ones(512, 640, CV_32F);
    std::cout << "\n\n\n---- PRUEBA 5 -----:\n";
    bool read = readNucMat(filePath, mat, 4);
    
    
    // TEST 6
    // Llamamos a setOffsetForcingNucValue, que cargue la matriz
    std::cout << "\n\n\n---- PRUEBA 6 -----:\n";    
    cv::Mat offset = cv::Mat::ones(512, 640, CV_32F);
    setOffsetForcingNucValue(tint);

}
