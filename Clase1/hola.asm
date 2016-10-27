segment datos data
	msg db 'Hola Mundo$'
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
	mov dx,msg ; lea dx,[msg]
	mov ah,9h
	int 21h
	mov ah,4ch ; retornar al SO
	int 21h
	