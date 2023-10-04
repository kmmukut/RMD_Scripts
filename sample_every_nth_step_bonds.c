#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h> // Include time library

int main(int argc, char *argv[])
{
    clock_t start, end; // Declare start and end variables
    double cpu_time_used;

    start = clock(); // Start the timer

    if (argc != 4)
    {
        printf("Usage: ./extract_bonds <input file> <output file> <timestep interval>\n");
        return 1;
    }

    FILE *inputFile, *outputFile;
    char line[256];
    int timestep = 0;
    int interval = atoi(argv[3]);

    inputFile = fopen(argv[1], "r");
    outputFile = fopen(argv[2], "w");

    if (inputFile == NULL || outputFile == NULL)
    {
        printf("Error opening file.\n");
        return 1;
    }

    while (fgets(line, sizeof(line), inputFile))
    {
        if (strncmp(line, "# Timestep", 10) == 0)
        {
            // read the timestep value from the same line
            sscanf(line, "# Timestep %d", &timestep);

            if (timestep % interval == 0)
            {
                fprintf(outputFile, "# Timestep %d\n", timestep);
                while (fgets(line, sizeof(line), inputFile) && strncmp(line, "# Timestep", 10) != 0)
                {
                    fputs(line, outputFile);
                }
            }
        }
    }

    fclose(inputFile);
    fclose(outputFile);

    end = clock();                                            // End the timer
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC; // Calculate time taken

    printf("Time taken: %f seconds\n", cpu_time_used); // Print time taken

    return 0;
}
