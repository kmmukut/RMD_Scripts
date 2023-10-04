program extract_dumps
    implicit none
    integer :: timestep, interval
    character(len=256) :: line
    character(len=256) :: input_file, output_file
    integer :: iostat

    if (command_argument_count() /= 3) then
        print *, 'Usage: ./extract_dumps <input file> <output file> <timestep interval>'
        stop
    end if

    call get_command_argument(1, input_file)
    call get_command_argument(2, output_file)
    call get_command_argument(3, line)
    read(line, *) interval

    open(unit=10, file=input_file, status='old', action='read', iostat=iostat)
    if (iostat /= 0) then
        print *, 'Error opening file.'
        stop
    end if

    open(unit=20, file=output_file, status='unknown', action='write', iostat=iostat)
    if (iostat /= 0) then
        print *, 'Error opening file.'
        stop
    end if

    timestep = 0
    do
        read(10, '(a)', iostat=iostat) line
        if (iostat /= 0) exit

        if (line(1:14) == 'ITEM: TIMESTEP') then
            read(10, *) timestep

            if (mod(timestep, interval) == 0) then
                write(20, '(a)') 'ITEM: TIMESTEP'
                write(20, *) timestep

                do
                    read(10, '(a)', iostat=iostat) line
                    if (iostat /= 0 .or. line(1:14) == 'ITEM: TIMESTEP') exit

                    write(20, '(a)') trim(line)
                end do
            end if
        end if
    end do

    close(10)
    close(20)
end program extract_dumps
