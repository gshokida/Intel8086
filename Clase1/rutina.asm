segment datos data


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
    	
	mov ah,4ch ; retornar al SO
	int 21h
	
PRINTMSG:
	mov ah,9h
	int 21h
	ret