segment datos data
	msgIng db "Ingrese un texto(max 5):$"
	msgMostr db 10,13,"Usted ingreso: $"
	db 6
	db 0
cadena times 6 resb 1
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
    
	mov dx,msgIng
	call PrintMsg
	mov dx,cadena-2
	mov ah,0ah
	int 21h
	
	mov ax,0ah
	mov al,[cadena-1]
	mov si,ax
	mov byte[cadena+si],"$"
	
	mov dx,msgMostr
	call PrintMsg
	mov dx,cadena
	call PrintMsg
	
	mov ah,4ch ; retornar al SO
	int 21h
	
PrintMsg:
	mov ah,9h
	int 21h
	ret