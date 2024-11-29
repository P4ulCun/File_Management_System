.section .note.GNU-stack,"",@progbits
.data
    vect: .space 4000
    operatii: .space 4
    cod_operatie: .space 4
    nr_fisiere: .space 4
    ID_fisier: .space 4
    size_fisier: .space 4
    size_of_memory: .long 1000
    //memory size in bytes for this example

    print_ADD: .asciz "%d: (%d, %d)\n"
    print_test: .asciz "%d\n"

    scan_operatii: .asciz "%d"
    scan_cod_operatie: .asciz "%d"
    scan_nr_fisiere: .asciz "%d"
    scan_ID_fisier: .asciz "%d"
    scan_size_fisier: .asciz "%d"
.text
ADD:
    lea vect, %edi

    movl size_fisier, %eax
    xorl %edx, %edx
    movl $8, %ebx
    divl %ebx

    cmpl $0, %edx
    je ADD_flag
//in eax am pus size-ul in blocuri
    incl %eax

ADD_flag:
    movl $0, %ecx
    // cu ecx trec prin memorie
    movl $0, %edx
    //edx counter de blocuri
    movl $0, %esi
    //in esi tin indexul de la inceputul secventei de 0
ADD_loop:
// daca am ajuns la sfarsitul memoriei nu pot sa pun fisierul
    cmpl size_of_memory, %ecx
    je cant_ADD

    movl $0, %ebx
    //aici e problema la vector
    cmpl (%edi, %ecx, 4), %ebx
    jne ADD_count_reset

    incl %edx

    cmpl %edx, %eax
    je ADD_valid_block

    incl %ecx

    jmp ADD_loop
ADD_count_reset:
    incl %ecx
    movl %ecx, %esi

    movl $0, %edx

    jmp ADD_loop
ADD_valid_block:
    movl %esi, %edx

ADD_section_fill:
    cmpl %ecx, %esi
    jg ADD_done

    movl ID_fisier, %eax
    movl %eax, (%edi, %esi, 4)
    incl %esi

    jmp ADD_section_fill
    //umplu de la index de inceput %esi, pana la index de final %ecx
ADD_done:
// in esi inceputul secventei
//in ecx sfarsitul secventei
//trb sa dau print

    pushl %ecx
    pushl %edx
    pushl ID_fisier
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %edx
    popl %ecx

    ret
cant_ADD:
    pushl ID_fisier
    pushl $0
    pushl $0
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    //afisez (0,0)

    ret
.global main
main:
    lea vect, %edi
    movl $0, %ecx
init_vect:
    cmpl size_of_memory, %ecx
    je done

    movl $0, %ebx
    movl %ebx, (%edi, %ecx, 4)

    incl %ecx
    jmp init_vect
done:
    pushl $operatii
    pushl $scan_operatii
    call scanf
    popl %ebx
    popl %ebx

    movl $0, %ecx
loop_operatii:
    cmpl operatii, %ecx
    je operatii_done

    pushl %ecx
    pushl $cod_operatie
    pushl $scan_cod_operatie
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx

    movl cod_operatie, %eax
// verific codul pentru instructiunea ADD
    cmpl $1, %eax
    jne continue_to_2

instruction_ADD:
    pushl %eax
    pushl %ecx
    pushl $nr_fisiere
    pushl $scan_nr_fisiere
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx
    popl %eax

    movl $0, %eax
loop_fisier_ADD:
    cmpl nr_fisiere, %eax
    je loop_operatii_inc

    pushl %eax
    pushl %ecx
    pushl $ID_fisier
    pushl $scan_ID_fisier
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx
    popl %eax

    pushl %eax
    pushl %ecx
    pushl $size_fisier
    pushl $scan_size_fisier
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx
    popl %eax

    pushl %eax
    pushl %ecx
    call ADD
    popl %ecx
    popl %eax

    incl %eax

    jmp loop_fisier_ADD
continue_to_2:

loop_operatii_inc:
    incl %ecx

    jmp loop_operatii
operatii_done:

et_exit:
    pushl $0
    call fflush
    popl %eax
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
