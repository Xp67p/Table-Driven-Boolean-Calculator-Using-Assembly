INCLUDE Irvine32.inc

.data
; Menu
menu1   BYTE "1. x AND y",0
menu2   BYTE "2. x OR y",0
menu3   BYTE "3. NOT x",0
menu4   BYTE "4. x XOR y",0
menu5   BYTE "5. Exit",0
prompt  BYTE "Enter choice (1-5): ",0

;Messages
msgAnd  BYTE "Performing AND",0
msgOr   BYTE "Performing OR",0
msgNot  BYTE "Performing NOT",0
msgXor  BYTE "Performing XOR",0
msgExit BYTE "Goodbye!",0

;Input prompts
askX    BYTE "Enter x: ",0
askY    BYTE "Enter y: ",0

;Result labels
labBin  BYTE "Binary: ",0
labDec  BYTE "Decimal: ",0

; Data
xVal DWORD ?
yVal DWORD ?
resVal DWORD ?

; Lookup table
opTable DWORD OFFSET DoAND, OFFSET DoOR, OFFSET DoNOT, OFFSET DoXOR

.code
main PROC
menuLoop:
    ; show menu
    mov edx, OFFSET menu1
    call WriteString, call Crlf
    mov edx, OFFSET menu2
    call WriteString, call Crlf
    mov edx, OFFSET menu3
    call WriteString, call Crlf
    mov edx, OFFSET menu4
    call WriteString, call Crlf
    mov edx, OFFSET menu5
    call WriteString, call Crlf




    ;read choice
    mov edx, OFFSET prompt
    call WriteString
    call ReadDec   ; eax = choice



    cmp eax, 5
    je exitProg


    ;check valid from 1 to 4
    cmp eax, 1
    jb menuLoop
    cmp eax, 4
    ja menuLoop



    ;table-driven call
    dec eax
    mov esi, OFFSET opTable
    call DWORD PTR [esi + eax*4]
    jmp menuLoop



exitProg:
    mov edx, OFFSET msgExit
    call WriteString
    call Crlf
    exit
main ENDP


;Operations 
DoAND PROC
    mov edx, OFFSET msgAnd
    call WriteString, call Crlf
    call GetTwo
    mov eax, xVal
    and eax, yVal
    mov resVal, eax
    call ShowResult
    ret
DoAND ENDP



DoOR PROC
    mov edx, OFFSET msgOr
    call WriteString, call Crlf
    call GetTwo
    mov eax, xVal
    or eax, yVal
    mov resVal, eax
    call ShowResult
    ret
DoOR ENDP

DoNOT PROC
    mov edx, OFFSET msgNot
    call WriteString, call Crlf
    call GetOne
    mov eax, xVal
    not eax
    mov resVal, eax
    call ShowResult
    ret
DoNOT ENDP



DoXOR PROC
    mov edx, OFFSET msgXor
    call WriteString, call Crlf
    call GetTwo
    mov eax, xVal
    xor eax, yVal
    mov resVal, eax
    call ShowResult
    ret
DoXOR ENDP



;Inputs
GetTwo PROC
    mov edx, OFFSET askX
    call WriteString
    call ReadDec
    mov xVal, eax


    mov edx, OFFSET askY
    call WriteString
    call ReadDec
    mov yVal, eax
    ret
GetTwo ENDP

GetOne PROC
    mov edx, OFFSET askX
    call WriteString
    call ReadDec
    mov xVal, eax
    ret
GetOne ENDP

;Output 
ShowResult PROC
    mov edx, OFFSET labBin
    call WriteString
    mov eax, resVal
    call PrintBin32
    call Crlf

    mov edx, OFFSET labDec
    call WriteString
    mov eax, resVal
    call WriteInt
    call Crlf, call Crlf
    ret
ShowResult ENDP

;Print eax
PrintBin32 PROC
    push eax
    push ecx
    push ebx


    mov ecx, 32
    mov ebx, eax
bitLoop:
    shl ebx, 1
    jc one
    mov al,'0'
    jmp out
one:
    mov al,'1'
out:
    call WriteChar
    loop bitLoop


    pop ebx
    pop ecx
    pop eax
    ret
PrintBin32 ENDP

END main
