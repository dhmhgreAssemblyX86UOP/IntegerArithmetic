TITLE Integer Arithmetic Examples
INCLUDE Irvine32.inc


.data
var dword ? 
var1 qword ? 



.code
mergeDXAX16product PROC	uses ebx
 ; Merge value from AX and DX to a 32-bit value using registers 
mov bx,ax ; save ax value
mov ax,dx
shl eax,16
mov ax,bx
ret
mergeDXAX16product ENDP

mergeDXAX16productMemory PROC	
push ebp
mov ebp,esp
sub esp,4
push esi


; Merge value from AX and DX to a 32-bit value using local variable
lea esi,[ebp-4]
mov word ptr [esi],ax
lea esi,[ebp-2]
mov word ptr [esi],dx
mov eax,[ebp-4]

pop esi
mov esp,ebp
pop ebp
ret
mergeDXAX16productMemory ENDP

mergeEDXEAX32productMemory PROC	
; Input arguments : The offset of a 64-bit value in memory
push ebp
mov ebp,esp
push esi

; Merge value from AX and DX to a 32-bit value using local variable
mov esi,[ebp+8]
mov dword ptr [esi],eax
add esi,4
mov dword ptr [esi],edx

pop esi
mov esp,ebp
pop ebp
ret 4
mergeEDXEAX32productMemory ENDP

splitQuadWord2EDXEAX PROC
; Input arguments : The offset of a 64-bit value in memory
push ebp
mov ebp,esp
push esi

mov esi,[ebp+8]
mov eax,dword ptr [esi]
add esi,4
mov edx,dword ptr [esi]

pop esi
mov esp,ebp
pop ebp
ret 4
splitQuadWord2EDXEAX ENDP


main PROC

; Multiplication 8x8
; 
mov al, 20
mov bl, 20
mul bl	   ;result = 400>255 raises carry flag 


; Multiplication 16x16
mov ax,20
mov bx,20
mul bx	   ;result = 400<65535 no carry flag

mov ax,60000
mov bx,2
mul bx	   ;result = 120000>65535 raises carry flag

;call mergeDXAX16product
call mergeDXAX16productMemory

;Multiplication 32x32
mov eax,4294967295
mov ebx,2
mul ebx	   ;result = 120000<4294967295 no carry flag

push offset var1
call mergeEDXEAX32productMemory

; Division 64divident/32divisor
mov eax,0
mov edx,0
push offset var1
call splitQuadWord2EDXEAX
mov ebx,4294967295
div ebx	   ;result = 2


;Division 16/8
mov edx,0FFFFFFFFh
mov ax, 257
cwd
mov bx, 1
div bx	   ;result = 111


exit
main ENDP
END main



