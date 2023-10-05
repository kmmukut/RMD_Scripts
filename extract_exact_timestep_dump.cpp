#include <fstream>
#include <iostream>
#include <string>
#include <ctime>

#define MAXLINE 256 // Maximum number of characters in a line

int main(int argc, char *argv[])
{
    clock_t start_cpu, end_cpu;
    time_t start_wall, end_wall;
    double cpu_time_used;
    double wall_time_used;

    start_cpu = clock();
    start_wall = time(NULL);

    if (argc != 4)
    {
        std::cout << "Usage: ./extract_dumps <input file> <output file> <exact timestep>\n";
        return 1;
    }

    std::ifstream inputFile(argv[1]);
    std::ofstream outputFile(argv[2]);
    std::string line;
    line.reserve(MAXLINE); // Reserve memory for long lines
    int timestep = 0;
    int exactTimestep = atoi(argv[3]);

    if (!inputFile.is_open() || !outputFile.is_open())
    {
        std::cout << "Error opening file.\n";
        return 1;
    }

    while (inputFile.peek() != EOF)
    {
        if (inputFile.peek() == 'I') // Check if the line starts with 'I'
        {
            std::getline(inputFile, line);
            if (line.substr(0, 14) == "ITEM: TIMESTEP")
            {
                // read the timestep value from the next line
                if (std::getline(inputFile, line))
                {
                    timestep = atoi(line.c_str());
                }

                if (timestep == exactTimestep)
                {
                    outputFile << "ITEM: TIMESTEP\n";
                    outputFile << timestep << "\n";
                    while (std::getline(inputFile, line) && line.substr(0, 14) != "ITEM: TIMESTEP")
                    {
                        outputFile << line << "\n";
                    }
                    break; // Exit the loop once we've found and written the exact timestep
                }
                else if (timestep > exactTimestep)
                {
                    break; // Exit the loop if we've passed the exact timestep
                }
            }
        }
        else
        {
            inputFile.ignore(MAXLINE, '\n'); // Ignore the rest of the line
        }
    }

    inputFile.close();
    outputFile.close();

    end_cpu = clock();
    end_wall = time(NULL);
    cpu_time_used = ((double)(end_cpu - start_cpu)) / CLOCKS_PER_SEC;
    wall_time_used = difftime(end_wall, start_wall);

    std::cout << "CPU Time taken: " << cpu_time_used << " seconds\n";
    std::cout << "Wall-clock Time taken: " << wall_time_used << " seconds\n";

    return 0;
}
