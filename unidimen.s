.section .note.GNU-stack,"",@progbits
.data
    vect: .space 1024
    operatii: .space 4
    cod_operatie: .space 4
    nr_fisiere: .space 4
    ID_fisier: .space 4
    size_fisier: .space 4
    size_of_memory: .long 1024
    //memory size in bytes for this example

    print_ADD: .asciz "%d: (%d, %d)\n"
    print_GET: .asciz "(%d, %d)\n"
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

    movb $0, %bl
    cmpb (%edi, %ecx, 1), %bl
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

    movb ID_fisier, %al
    movb %al, (%edi, %esi, 1)
    incl %esi

    jmp ADD_section_fill
    //umplu de la index de inceput %esi, pana la index de final %ecx
ADD_done:
// in edx inceputul secventei
//in ecx sfarsitul secventei
//trb sa dau print

    /*pushl %ecx
    pushl %edx
    pushl ID_fisier
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %edx
    popl %ecx*/

    //sau

    // in esi se afla inceputul de secventa
    // in ebp se afla sfarsitul de secventa
    movl %ecx, %ebp
    movl %edx, %esi

    ret
cant_ADD:
    /*pushl ID_fisier
    pushl $0
    pushl $0
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx*/
    //afisez (0,0)

    //sau

    movl $0, %ebp
    ret

GET:
    lea vect, %edi

    movl $0, %ecx
    movl $0, %edx
    movl $0, %esi
    movb ID_fisier, %al
GET_loop:
    cmpl size_of_memory, %ecx
    je GET_final_check

    cmpb (%edi, %ecx, 1), %al
    jne GET_start_reset

    incl %edx
    incl %ecx

    jmp GET_loop
GET_start_reset:
    cmpl $0, %edx
    jne GET_done

    incl %ecx
    movl %ecx, %esi

    jmp GET_loop

GET_done:
    decl %ecx

    /*pushl %ecx
    pushl %esi
    pushl $print_GET
    call printf
    popl %ebx
    popl %ebx
    popl %ebx*/

    //sau

    // in esi se afla inceputul de secventa
    // in ebp se afla sfarsitul de secventa
    movl %ecx, %ebp
//  si in esi se afla inceputul de secventa
    ret
GET_final_check:
    /*pushl $0
    pushl $0
    pushl $print_GET
    call printf
    popl %ebx
    popl %ebx
    popl %ebx*/

    //sau

//mai verific sfarsitul de vector
    decl %ecx
    movb ID_fisier, %al
    cmpb %al, (%edi, %ecx, 1)
    jne cant_GET

    movl %ecx, %ebp

    ret
cant_GET:
    movl $0, %ebp

    ret

DELETE:
    //fac cu secvente de nr
    //gasesc o secventa de numere la fel si returnez indecsii
    //daca secventa de nr este egala cu ID_fisier inlocuiesc cu 0 toate aparitiile nr
    //si daca e 0 doar mut indecsii, atat
    lea vect, %edi

    movl $0, %ecx
    movl $0, %edx
    movl $0, %esi
    movb ID_fisier, %al
    //in edx tin lungimea secventei 
DELETE_loop:
    cmpl size_of_memory, %ecx
    je DELETE_final_check

    cmpb (%edi, %ecx, 1), %al
    jne DELETE_reset

    incl %edx
    movb $0, %bl
    movb %bl, (%edi, %ecx, 1)
    incl %ecx

    jmp DELETE_loop
DELETE_reset:
    cmpl $0, %edx
    jne DELETE_done

    incl %ecx
    movl %ecx, %esi

    jmp DELETE_loop

DELETE_done:
    decl %ecx
    // in esi se afla inceputul de secventa
    // in ebp se afla sfarsitul de secventa
    movl %ecx, %ebp

    ret
DELETE_final_check:
    decl %ecx

    cmpl $0, %edx
    je cant_DELETE

    movl %ecx, %ebp

    ret
cant_DELETE:
    movl $0, %esi
    movl $0, %ebp

    ret

DEFRAG:
    lea vect, %edi

    movl $0, %ecx
    movl $0, %edx
DEFRAG_loop:
    cmpl size_of_memory, %ecx
    je DEFRAG_done

    movb $0, %al
    cmpb %al, (%edi, %ecx, 1)
    jne DEFRAG_potential

    incl %edx
    incl %ecx

    jmp DEFRAG_loop
DEFRAG_potential:
    cmpl $0, %edx
    je DEFRAG_inc

    //resetez contorul pentru secventa de 0
    movl $0, %edx
    movl %edx, ID_fisier
    movb (%edi, %ecx, 1), %al
    movb %al, ID_fisier
    //in esi sau ID_fisier se afla ID-ul fisierului de defregmentat

    //defregmentez

    //delete ID-fisier
    //delete returneaza indecsii la ce a sters
    //cu indecsii pot calcula length

    pushl %ecx
    pushl %edx
    pushl %eax
    call DELETE
    //da return la esi inceput si ebp sfarsit

    subl %esi, %ebp
    incl %ebp

    //in ebp se afla lenght si e corect

    movl $8, %eax
    xorl %edx, %edx
    mull %ebp
    movl %eax, %ebp

    popl %eax
    popl %edx
    popl %ecx

    //add id fisier de un lenght

    movl %ebp, size_fisier
    pushl %ecx
    pushl %edx
    pushl %eax
    call ADD
    popl %eax
    popl %edx
    popl %ecx
    //in ebp se afla sfarsitul de secventa
    
    incl %ebp
    movl %ebp, %ecx

    jmp DEFRAG_loop
DEFRAG_inc:
    incl %ecx

    jmp DEFRAG_loop
DEFRAG_done:

    ret

AFISARE_memorie:
    lea vect, %edi

    movl $1, %ecx
    movl $0, %esi
AFISARE_loop:
    cmpl size_of_memory, %ecx
    je AFISARE_final_check

    movb (%edi, %ecx, 1), %al
    movl %ecx, %ebx
    decl %ebx
    cmpb (%edi, %ebx, 1), %al
    jne AFISARE_reset

    incl %ecx

    jmp AFISARE_loop
AFISARE_reset:
    movb $0, %dl
    cmpb (%edi, %ebx, 1), %dl
    je AFISARE_inc

    movl $0, %edx
    movb (%edi, %ebx, 1), %dl

    pushl %ecx
    pushl %ebx
    pushl %esi
    pushl %edx
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx
AFISARE_inc:
    movl %ecx, %esi
    incl %ecx

    jmp AFISARE_loop
AFISARE_final_check:
    decl %ecx
    movl %ecx, %ebx
    movb (%edi, %ebx, 1), %al

    cmpb $0, %al
    je AFISARE_done

    movl $0, %edx
    movb (%edi, %ebx, 1), %dl

    pushl %ecx
    pushl %ebx
    pushl %esi
    pushl %edx
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx
AFISARE_done:

    ret
.global main
main:
    lea vect, %edi
    movl $0, %ecx
init_vect:
    /*cmpl size_of_memory, %ecx
    je done

    movl $0, %ebx
    movl %ebx, (%edi, %ecx, 4)

    incl %ecx
    jmp init_vect*/
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
//eax e codul de intructiune
    movl cod_operatie, %eax

// verific codul pentru instructiunea ADD
    cmpl $1, %eax
    jne continue_GET

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

//aici eax e pentru loop nr fisiere
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

    cmpl $0, %ebp
    je ADD_afisare

    pushl %ecx
    pushl %eax
    pushl %ebp
    pushl %esi
    pushl ID_fisier
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %eax
    popl %ecx
    // in esi se afla inceputul de secventa
    // in ebp se afla sfarsitul de secventa
    jmp ADD_inc
ADD_afisare:

    pushl %ecx
    pushl %eax
    pushl $0
    pushl $0
    pushl $print_GET
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %eax
    popl %ecx
ADD_inc:
    incl %eax

    jmp loop_fisier_ADD
continue_GET:
    cmpl $2, %eax
    jne continue_DELETE

    pushl %ecx
    pushl $ID_fisier
    pushl $scan_ID_fisier
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx

    pushl %ecx
    call GET
    popl %ecx

    cmpl $0, %ebp
    je GET_afisare

    pushl %ecx
    pushl %ebp
    pushl %esi
    pushl $print_GET
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx

    jmp loop_operatii_inc
GET_afisare:
    pushl %ecx
    pushl $0
    pushl $0
    pushl $print_GET
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx
    // in esi se afla inceputul de secventa
    // in ebp se afla sfarsitul de secventa
    jmp loop_operatii_inc
continue_DELETE:
    cmpl $3, %eax
    jne continue_DEFRAG

    pushl %ecx
    pushl $ID_fisier
    pushl $scan_ID_fisier
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx

    pushl %ecx
    call DELETE
    popl %ecx

    pushl %ecx
    call AFISARE_memorie
    popl %ecx

    jmp loop_operatii_inc
continue_DEFRAG:
    pushl %ecx
    call DEFRAG
    popl %ecx

    pushl %ecx
    call AFISARE_memorie
    popl %ecx

    jmp loop_operatii_inc
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
