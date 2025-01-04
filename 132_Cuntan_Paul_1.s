.section .note.GNU-stack,"",@progbits
.data
    dir_name: .space 256
    file_name: .space 256
    file_size: .space 4
    dir_dot: .byte '.'
    buffer: .space 144

    vect: .space 262144
    // size of memory line (1024) * 256 de linii (nr max de fisiere)
    operatii: .space 4
    cod_operatie: .space 4
    nr_fisiere: .space 4
    ID_fisier: .space 4
    offset_add: .space 4
    size_fisier: .space 4
    size_of_memory: .long 262144
    size_of_memory_line: .long 1024
    //memory size in bytes for this example

    //for concrete
    
    format_snprintf: .asciz "%s/%s"

    print_ADD: .asciz "%d: ((%d, %d), (%d, %d))\n"
    print_GET: .asciz "((%d, %d), (%d, %d))\n"
    print_test: .asciz "%d\n"
    print_string: .asciz "%s\n"
    print_endl: .asciz "\n"
    print_int: .asciz "%d\n"
    print_urgenta: .asciz "!! %d !!\n"

    scan_path: .asciz "%s"
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
    addl offset_add, %ecx
    // cu ecx trec prin memorie

    movl $0, %edx
    // ca sa initializez esi cu 0 chiar daca incep de la inceput

    cmpl $0, %ecx
    je ADD_offset

    pushl %eax

    movl %ecx, %eax
    xorl %edx, %edx
    movl size_of_memory_line, %ebx
    divl %ebx

    popl %eax

ADD_offset:
    //linia curenta cu offset cu tot
    movl %edx, %esi
    //in esi tin linia curenta / pe care se va afla fisierul adaugat
    movl $0, %edx
    //edx counter de blocuri
    movl $0, %ebp
    addl offset_add, %ebp
    //in ebp tin indexul start_col 
ADD_loop:
// daca am ajuns la sfarsitul memoriei nu pot sa pun fisierul
    cmpl size_of_memory, %ecx
    je cant_ADD

    //trec prin elementele fiecarei linii
    cmpl $0, %ecx
    je ADD_loop_continue

    pushl %eax
    pushl %edx

    movl %ecx, %eax
    xorl %edx, %edx
    movl size_of_memory_line, %ebx
    divl %ebx

    movl %edx, %ebx

    popl %edx
    popl %eax
//check line max

    cmpl $0, %ebx
    jne ADD_loop_continue

    incl %esi
    movl %ecx, %ebp
    movl $0, %edx
    //changing the current line
ADD_loop_continue:
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
    movl %ecx, %ebp

    movl $0, %edx

    jmp ADD_loop
ADD_valid_block:
    movl %ebp, %edx

ADD_section_fill:
    cmpl %ecx, %ebp
    jg ADD_done

    movb ID_fisier, %al
    movb %al, (%edi, %ebp, 1)
    incl %ebp

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

    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    movl %ecx, %ebx
    movl %edx, %ebp

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

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

    movl $0, %ebx
    ret

GET:
    lea vect, %edi

    movl $0, %ecx
    movl $0, %edx
    movl $0, %esi
    movl $0, %ebp
    movb ID_fisier, %al
GET_loop:
    cmpl size_of_memory, %ecx
    je GET_final_check

    cmpl $0, %ecx
    je GET_loop_continue

    pushl %eax
    pushl %edx

    movl %ecx, %eax
    xorl %edx, %edx
    movl size_of_memory_line, %ebx
    divl %ebx

    movl %edx, %ebx

    popl %edx
    popl %eax
    
    cmpl $0, %ebx
    jne GET_loop_continue

    cmpl $0, %edx
    jne GET_done

    incl %esi
    movl %ecx, %ebp

    incl %ecx

GET_loop_continue:
    cmpb (%edi, %ecx, 1), %al
    jne GET_start_reset

    incl %edx
    incl %ecx

    jmp GET_loop
GET_start_reset:
    /*pushl %eax
    pushl %edx
    pushl %ecx
    

    pushl $print_test
    call printf
    popl %ebx

    popl %ecx
    popl %edx
    
    popl %eax*/

    cmpl $0, %edx
    jne GET_done

    incl %ecx
    movl %ecx, %ebp

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

    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    movl %ecx, %ebx

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

//  si in esi se afla inceputul de secventa
    ret
GET_final_check:

    decl %ecx
    movb ID_fisier, %al
    cmpb %al, (%edi, %ecx, 1)
    jne cant_GET

    movl %ecx, %ebx

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

    ret

cant_GET:
    movl $0, %ebx

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
    movl $0, %ebp
    movb ID_fisier, %al
    //in edx tin lungimea secventei 
DELETE_loop:
    cmpl size_of_memory, %ecx
    je DELETE_final_check

    cmpl $0, %ecx
    je DELETE_loop_continue

    pushl %eax
    pushl %edx

    movl %ecx, %eax
    xorl %edx, %edx
    movl size_of_memory_line, %ebx
    divl %ebx

    movl %edx, %ebx

    popl %edx
    popl %eax
//check line max

    cmpl $0, %ebx
    jne DELETE_loop_continue

    movl %ecx, %ebx
    decl %ebx
    cmpl $0, %edx
    jne DELETE_done

    incl %esi
    movl %ecx, %ebp
    //changing the current line

DELETE_loop_continue:
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
    movl %ecx, %ebp

    jmp DELETE_loop

DELETE_done:
    decl %ecx

    movl %ecx, %ebx
    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col

    /*pushl %ecx
    pushl $print_test
    call printf
    popl %eax
    popl %ecx

    pushl %ebp
    pushl $print_test
    call printf
    popl %eax
    popl %ebp */

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

    /*pushl %esi
    pushl $print_test
    call printf
    popl %eax
    popl %esi

    pushl %ebp
    pushl $print_test
    call printf
    popl %eax
    popl %esi
    
    pushl %ebx
    pushl $print_test
    call printf
    popl %eax
    popl %esi*/

    ret
DELETE_final_check:
    decl %ecx

    cmpl $0, %edx
    je cant_DELETE

    movl %ecx, %ebx

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

    ret
cant_DELETE:
    movl $0, %esi
    movl $0, %ebp

    ret

DEFRAG:
    lea vect, %edi
    movl $0, %ebx
    movl %ebx, offset_add

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
    //aflu daca inainte de fisier am o secventa de 0, deci potential spatiu de defragmentat

    jmp DEFRAG_loop
DEFRAG_potential:
    cmpl $0, %edx
    je DEFRAG_inc

    //resetez contorul pentru secventa de 0
    movl $0, %edx
    movl %edx, ID_fisier
    movb (%edi, %ecx, 1), %al
    movb %al, ID_fisier

    //defregmentez

    //delete ID-fisier
    //delete returneaza indecsii la ce a sters
    //cu indecsii pot calcula length

    pushl %ecx

    pushl %edx
    pushl %eax
    call DELETE
    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    subl %ebp, %ebx
    incl %ebx
    //in ebx se afla lenght

    movl $8, %eax
    xorl %edx, %edx
    mull %ebx
    movl %eax, %ebx

    popl %eax
    popl %edx

    popl %ecx

    /*pushl %eax
    pushl %ecx
    pushl %edx
    pushl %ebx
    pushl $print_test
    call printf
    popl %ebx
    popl %ebx
    popl %edx3
-
    popl %eax*/

    //add id fisier de un lenght

    movl %ebx, size_fisier

    pushl %ecx
    pushl %edx
    pushl %eax
    call ADD
    popl %eax
    popl %edx
    popl %ecx
    //in ebx se afla end_col (coloana) si eu il vreau adunat cu linia pe care e
    pushl %edx
    pushl %eax

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    addl %eax, %ebx

    popl %eax
    popl %edx

    incl %ebx
    movl %ebx, %ecx

    movl %ecx, offset_add

    //offset pentru add ca sa mi ia in ordine

    jmp DEFRAG_loop
DEFRAG_inc:
    incl %ecx
    //movl %ecx, offset_add

    jmp DEFRAG_loop
DEFRAG_done:
    pushl %ebx

    movl $0, %ebx
    movl %ebx, offset_add

    popl %ebx

    ret

AFISARE_memorie:
    lea vect, %edi

    movl $1, %ecx
    movl $0, %esi
    movl $0, %ebp
AFISARE_loop:
    cmpl size_of_memory, %ecx
    je AFISARE_final_check

    pushl %eax
    pushl %edx

    movl %ecx, %eax
    xorl %edx, %edx
    movl size_of_memory_line, %ebx
    divl %ebx

    movl %edx, %ebx

    popl %edx
    popl %eax
//check line max

    cmpl $0, %ebx
    je AFISARE_fin_lin

    //incl %esi
    //movl %ecx, %ebp

AFISARE_loop_continue:
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

    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    pushl %edx

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

    popl %edx

    pushl %ebx
    pushl %esi
    pushl %ebp
    pushl %esi
    pushl %edx
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %ecx

    jmp AFISARE_inc
AFISARE_fin_lin:
    movl $0, %eax
    movl %ecx, %ebx
    decl %ebx
    cmpb (%edi, %ebx, 1), %al
    je AFISARE_fin_inc

    movl $0, %edx
    movb (%edi, %ebx, 1), %dl

    pushl %ecx

    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    pushl %edx

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

    popl %edx

    pushl %ebx
    pushl %esi
    pushl %ebp
    pushl %esi
    pushl %edx
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %ecx

    incl %esi
    jmp AFISARE_inc
AFISARE_fin_inc:
    incl %esi
AFISARE_inc:
    movl %ecx, %ebp
    incl %ecx

    jmp AFISARE_loop
AFISARE_final_check:
    decl %ecx
    movl %ecx, %ebx
    movb $0, %dl
    cmpb (%edi, %ebx, 1), %dl
    je AFISARE_done

    movl $0, %edx
    movb (%edi, %ebx, 1), %dl

    pushl %ecx

    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    pushl %edx

    movl size_of_memory_line, %eax
    xorl %edx, %edx
    mull %esi
    subl %eax, %ebx
    subl %eax, %ebp

    popl %edx

    pushl %ebx
    pushl %esi
    pushl %ebp
    pushl %esi
    pushl %edx
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
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

    movl $0, %ebx
    movl %ebx, offset_add

    pushl %eax
    pushl %ecx
    call ADD
    popl %ecx
    popl %eax

    cmpl $0, %ebx
    je ADD_afisare
    //nu are loc in memorie
    pushl %ecx
    pushl %eax

    pushl %ebx
    pushl %esi
    pushl %ebp
    pushl %esi
    pushl ID_fisier
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %eax
    popl %ecx
    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    jmp ADD_inc
ADD_afisare:

    pushl %ecx
    pushl %eax

    pushl $0
    pushl $0
    pushl $0
    pushl $0
    pushl ID_fisier
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
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

    cmpl $0, %ebx
    je GET_afisare

    pushl %ecx

    pushl %ebx
    pushl %esi
    pushl %ebp
    pushl %esi
    pushl $print_GET
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %ecx

    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col
    jmp loop_operatii_inc
GET_afisare:
    pushl %ecx
    pushl $0
    pushl $0
    pushl $0
    pushl $0
    pushl $print_GET
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx
    
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
    cmpl $4, %eax
    jne continue_CONCRETE

    pushl %ecx
    call DEFRAG
    popl %ecx

    pushl %ecx
    call AFISARE_memorie
    popl %ecx

    jmp loop_operatii_inc

continue_CONCRETE:

    pushl %ecx
    pushl $dir_name
    pushl $scan_path
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx

    // incercam sa deschidem un director
    movl $dir_name, %eax

    pushl %ecx

    pushl %eax
    call opendir
    popl %ebx

    popl %ecx
    //si in eax ar trb sa fie pointer spre directorul meu / pointer to directory stream

    //loop prin fisierrele directorului
loop_dir:
    pushl %ecx

    pushl %eax
    call readdir
    popl %ebx

    popl %ecx

    // verific daca am ajuns la sfarsitul directorului
    cmpl $0, %eax
    je loop_dir_done

    //in ebx ramane pointerul spre strucutra de directoare

    // eax se afla un nou pointer spre structura dirent
    addl $11, %eax
    // adaug offset la pointer ca sa ma duca la elementul d_name din structura dirent

    // daca intalnesc directorul . sau .. incerc iar
    

    movl $0, %esi
    movl $0, %edx

    movb dir_dot, %dl
    cmpb (%eax, %esi, 1), %dl
    je read_next_file
// incerc urmatorul fisier din director
    pushl %ecx

    /*pushl %eax
    pushl $print_string
    call printf
    popl %edx
    popl %eax*/

    popl %ecx
// refac absolute path pentru fisier: snprintf(location, size of location, format of location, dir path, file_name) = absolute path to specified file
    pushl %ecx

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

    popl %ecx

// in filename se afla pathul absolut al directorului
    pushl %ecx

    /*pushl $file_name
    pushl $print_string
    call printf
    popl %edx
    popl %edx*/

    popl %ecx
// fac open pentru fiecare fisier ca sa aflu id ul si size ul
    pushl %ecx

    pushl $0
    pushl $file_name
    call open
    popl %edx
    popl %edx

    popl %ecx
//in eax se afla fd (descriptorul) fisierului curent
// trebuie sa aplic ID ului mod 255 + 1 ca sa fie un id valid
    /*pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx

    xorl %edx, %edx
    movl ID_fisier, %eax
    //in eax e id-ul
    movl $255, %ebx
    divl %ebx
    //in edx e restul modulo 255
    incl %edx
    //in edx e id-ul corect al fisierului
    movl %edx, ID_fisier

    popl %edx
    popl %ecx
    popl %ebx
    popl %eax  */
    movl %eax, ID_fisier

    pushl %ecx

    /*pushl %ebx
    pushl ID_fisier
    pushl $print_int
    call printf
    popl %edx
    popl %edx
    popl %ebx*/

    popl %ecx


    pushl %ecx

    pushl $buffer
    pushl ID_fisier
    call fstat
    popl %edx
    popl %edx

    popl %ecx

    movl $buffer, %eax
    addl $44, %eax
    // 44 offset ca sa ajung la st_size
    // e bine

    // in (%eax) se afla size-ul fisierului
    movl (%eax), %edx

    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    // transform size ul primit de la stat (in bytes) in kilobytes
    movl %edx, %eax
    xorl %edx, %edx
    movl $1024, %ebx
    divl %ebx

    movl %eax, size_fisier

    popl %edx
    popl %ecx
    popl %ebx
    popl %eax

    //calculez fd ce va intra in program
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx

    xorl %edx, %edx
    movl ID_fisier, %eax
    //in eax e id-ul
    movl $255, %ebx
    divl %ebx
    //in edx e restul modulo 255
    incl %edx
    //in edx e id-ul corect al fisierului
    movl %edx, ID_fisier

    popl %edx
    popl %ecx
    popl %ebx
    popl %eax

    //!!
    //acum trebuie sa verific daca fd ul este sau nu in memorie si sa l adaug

    pushl %ecx
    pushl %ebx

    // afisez fd si size

    pushl ID_fisier
    pushl $print_int
    call printf
    popl %edx
    popl %edx

    pushl size_fisier
    pushl $print_int
    call printf
    popl %edx
    popl %edx

    movl $8, %eax
    cmpl %eax, size_fisier
    jle is_in_memory_cant_add

    lea vect, %edi
    movl $0, %ecx
    movl $0, %eax
    movb ID_fisier, %al
is_in_memory_loop:
    cmpl size_of_memory, %ecx
    je is_in_memory_can_add

    cmpb %al, (%edi, %ecx, 1)
    je is_in_memory_cant_add

    incl %ecx
    jmp is_in_memory_loop

is_in_memory_can_add:
    // call add with fd and size
    movl $0, %ebx
    movl %ebx, offset_add

    call ADD

    cmpl $0, %ebx
    je is_in_memory_cant_add
    //nu are loc in memorie
    pushl %ecx
    pushl %eax

    pushl %ebx
    pushl %esi
    pushl %ebp
    pushl %esi
    pushl ID_fisier
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %eax
    popl %ecx
    // in esi se afla start/end_lin
    // in ebx se afla end_col
    // in ebp se afla start_col

    popl %ebx
    popl %ecx 

    jmp read_next_file

is_in_memory_cant_add:
    pushl %ecx
    pushl %eax

    pushl $0
    pushl $0
    pushl $0
    pushl $0
    pushl ID_fisier
    pushl $print_ADD
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %eax
    popl %ecx

    popl %ebx
    popl %ecx

    jmp read_next_file
read_next_file:
    movl %ebx, %eax
    // mut inapoi in eax pointerul spre directory stream

    jmp loop_dir

loop_dir_done:
    // need to close all the files and the directory that i've opened

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
