#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h> // Include time library

int main(int argc, char *argv[])
{
    clock_t start_cpu, end_cpu;  // Declare start and end variables for CPU time
    time_t start_wall, end_wall; // Declare start and end variables for wall-clock time
    double cpu_time_used;
    double wall_time_used;

    start_cpu = clock();     // Start the CPU timer
    start_wall = time(NULL); // Start the wall-clock timer

    if (argc != 4)
    {
        printf("Usage: ./extract_dumps <input file> <output file> <timestep interval>\n");
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
        if (strncmp(line, "ITEM: TIMESTEP", 14) == 0)
        {
            // read the timestep value from the next line
            if (fgets(line, sizeof(line), inputFile))
            {
                timestep = atoi(line);
            }

            if (timestep % interval == 0)
            {
                fputs("ITEM: TIMESTEP\n", outputFile);
                fprintf(outputFile, "%d\n", timestep);
                while (fgets(line, sizeof(line), inputFile) && strncmp(line, "ITEM: TIMESTEP", 14) != 0)
                {
                    fputs(line, outputFile);
                }
            }
        }
    }

    fclose(inputFile);
    fclose(outputFile);

    end_cpu = clock();                                                // End the CPU timer
    end_wall = time(NULL);                                            // End the wall-clock timer
    cpu_time_used = ((double)(end_cpu - start_cpu)) / CLOCKS_PER_SEC; // Calculate CPU time taken
    wall_time_used = difftime(end_wall, start_wall);                  // Calculate wall-clock time taken

    printf("CPU Time taken: %f seconds\n", cpu_time_used);         // Print CPU time taken
    printf("Wall-clock Time taken: %f seconds\n", wall_time_used); // Print wall-clock time taken

    return 0;
}
