#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
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

    return 0;
}
