segment datos data
		; Mensajes
		valorHardcode	db '00000001','$'

		
		
segment pila stack
		resb 64
stacktop:
		
segment codigo code
..start:
		mov ax,datos
		mov ds,ax
		mov ax,pila
		mov ss,ax
		mov sp,stacktop
		
inicio:
		
		
finPrograma:
		mov ah,4Ch
		int 21h
