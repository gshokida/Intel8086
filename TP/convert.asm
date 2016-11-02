;convierto sumo uno a un caracter
segment datos data

		mensajeIngreso db 'Ingresar un caracter$'
		dato resb 1
		res resb 1
		
		salto db 13,10,'$'

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
		lea dx,[mensajeIngreso]
		mov ah,9
		int 21h
		
		mov ah,1
		int 21h
		mov [dato],al
		
		call ejecutarEnter

		mov bh,[dato]
		add bh,1
		mov byte[res],bh
		
		mov dl,[res]
		mov ah,2
		int 21h
		
fin:
		mov ah,4ch
		int 21h
		
ejecutarEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret