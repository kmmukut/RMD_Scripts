program extract_bonds
    implicit none
    integer :: interval, timestep
    character(len=256) :: line
    character(len=100) :: input_file, output_file
    integer :: iostat, ios
    character(len=10) :: timestep_str

    if (command_argument_count() /= 3) then
        print *, 'Usage: ./extract_bonds <input file> <output file> <timestep interval>'
        stop
    end if

    call get_command_argument(1, input_file)
    call get_command_argument(2, output_file)
    call get_command_argument(3, timestep_str)
    read(timestep_str, *) interval

    open(unit=10, file=input_file, status='old', action='read', iostat=iostat)
    if (iostat /= 0) then
        print *, 'Error opening input file.'
        stop
    end if

    open(unit=20, file=output_file, status='unknown', action='write', iostat=iostat)
    if (iostat /= 0) then
        print *, 'Error opening output file.'
        stop
    end if

    do
        read(10, '(a)', iostat=ios) line
        if (ios /= 0) exit

        if (line(1:10) == '# Timestep') then
            read(line(12:), *) timestep

            if (mod(timestep, interval) == 0) then
                write(20, '(a)') trim(line)

                do
                    read(10, '(a)', iostat=ios) line
                    if (ios /= 0 .or. line(1:10) == '# Timestep') exit

                    write(20, '(a)') trim(line)
                end do
            end if
        end if
    end do

    close(10)
    close(20)
end program extract_bonds
