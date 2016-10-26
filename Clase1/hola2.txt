segment datos data
	msg db "Hola Mundo$"
	char1 resb 1
	char2 resb 1
segment pila stack
	resb 64
stacktop:
segment codigo code
..start:
	mov ax,data
	mov ds,ax
	mov ax,pila
	mov ss,ax
	mov sp,stacktop
    
	mov ah,1
	int 21h ; se imprime el caracter
	mov [char1],al
	
	mov ah,8
	int 21h ; no se muestra en pantalla
	mov [char2],al
	
	mov ah,4ch ; retornar al SO
	int 21h
	