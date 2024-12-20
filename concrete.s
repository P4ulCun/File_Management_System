.section .note.GNU-stack,"",@progbits
.data
    dir_name: .asciz "/home/paul/repos/Proiect_ASC/folder_text"
    file_name: .space 256
    file_size: .space 4
    dir_dot: .byte '.'
    buffer: .space 144


    ID_fisier: .space 4
    // adica punct in ascii

    format_snprintf: .asciz "%s/%s"
    print_endl: .asciz "\n"
    print_int: .asciz "%d\n"
    print_string: .asciz "%s\n"
    print_char: .asciz "%c\n"
    print_not_dir: .asciz "Not a directory\n"
    print_valid_dir: .asciz "This is a valid directory\n"
.text
.global main 

main:
// incercam sa deschidem un director
    movl $dir_name, %eax
    pushl %eax
    call opendir
    popl %ebx

    //si in eax ar trb sa fie pointer spre directorul meu / pointer to directory stream

    cmpl $0, %eax
    je Not_a_directory

    pushl %eax

    pushl $print_valid_dir
    call printf
    popl %edx

    popl %eax

loop_dir:

    pushl %eax
    call readdir
    popl %ebx

    // verific daca am ajuns la sfarsitul directorului
    cmpl $0, %eax
    je et_exit

    //in ebx ramane pointerul spre strucutra de directoare

    // eax se afla un nou pointer spre structura dirent
    addl $11, %eax
    // adaug offset la pointer ca sa ma duca la elementul d_name din structura dirent

    // daca intalnesc directorul . sau .. incerc iar
    movl $0, %ecx
    movl $0, %edx

    movb dir_dot, %dl
    cmpb (%eax, %ecx, 1), %dl
    je read_next_file
// incerc urmatorul fisier din director

    pushl %eax
    pushl $print_string
    call printf
    popl %edx
    popl %eax

// refac absolute path pentru fisier: snprintf(location, size of location, format of location, dir path, file_name) = absolute path to specified file
    pushl %ebx

    pushl %eax
    pushl $dir_name
    pushl $format_snprintf
    pushl $256
    pushl $file_name
    call snprintf
    popl %edx
    popl %edx
    popl %edx
    popl %edx
    popl %eax

    popl %ebx

// in filename se afla pathul absolut al directorului

    pushl $file_name
    pushl $print_string
    call printf
    popl %edx
    popl %edx

// fac open pentru fiecare fisier ca sa aflu id ul si size ul
    
    pushl $0
    pushl $file_name
    call open
    popl %edx
    popl %edx

//in eax se afla fd (descriptorul) fisierului curent
    pushl %ebx
    pushl %eax
    pushl $print_int
    call printf
    popl %edx
    popl %eax
    popl %ebx

    movl %eax, ID_fisier

    pushl $buffer
    pushl ID_fisier
    call fstat
    popl %edx
    popl %edx

    movl $buffer, %eax
    addl $44, %eax
    // 44 offset ca sa ajung la st_size
    // e bine

    // in (%eax) se afla size-ul fisierului
    pushl (%eax)
    pushl $print_int
    call printf
    popl %edx
    popl %eax

    pushl $print_endl
    call printf
    popl %edx
read_next_file:
    movl %ebx, %eax
    // mut inapoi in eax pointerul spre directory stream

    jmp loop_dir

Not_a_directory:

    pushl $print_not_dir
    call printf
    popl %eax

    jmp et_exit

//
    /*movl $5, %eax
    movl $file_name, %ebx
    int $0x80

    pushl %ebx
    pushl $print_int
    call printf
    popl %eax
    popl %eax

    movl $0x8d, %eax
    movl $1, %ebx
    movl %edi, %ecx
    movl $1, %edx
    int $0x80

    pushl %eax
    pushl $print_int
    call printf
    popl %eax
    popl %eax

    pushl %ebx
    pushl $print_int
    call printf
    popl %ebx
    popl %ebx

    pushl %ecx
    pushl $print_int
    call printf
    popl %ecx
    popl %ecx

    pushl %edi
    pushl $print_int
    call printf
    popl %edx
    popl %edx*/
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
