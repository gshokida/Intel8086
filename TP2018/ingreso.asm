segment datos data
		; Mensajes
		msjOctal 		db 'Ingrese su numero en octal (MAX 5 digitos)','$'
		msjHexa			db 'Ingrese su numero en hexa (MAX: 4 digitos)','$'
		
		msjOctalToHexa	db 'Su numero en hexa es:','$'
		msjHexaToOctal	db 'Su numero en octal es:','$'
		msj             db 'Me fui','$'
						db 6
						db 0
		cadena 			times 6 resb 1
		
		longitud  		resb 1
		
		; Para el enter
		salto 			db 13,10,'$'
		
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
		lea dx,[msjOctal]
		call imprimirMensaje
		
		; cargo desplaz del buffer
		lea dx,[cadena-2] 
		;ingreso de cadena
		mov ah,0ah
		int 21h 
		
		mov ax,0
		;copia la longitud de los caracters ingresados
		mov al,[cadena-1]		
		mov si,ax
		
		mov byte[cadena+si],'$' 
		
		mov bx,si
		
		mov byte[longitud],bl
		add byte[longitud],30h
		
		call imprimirEnter
		
		lea dx,[longitud]		
		call imprimirMensaje
		
		sub byte[longitud],30h

		call completarOctal


		;imprimo mensaje
		lea dx,[cadena]		
		call imprimirMensaje 
		
		
finPrograma:
		mov ah,4Ch
		int 21h
		

completarOctal:
		mov al,byte[longitud]
		cmp al,5h
		je  salirCompletarOctal
otroCompletarOctal:
		mov di,3
		lea	bx,[cadena]	

shiftOctal:
		mov cx,[bx+di]
		mov [bx+di+1],cx
		sub di,1
		cmp di,0
		jg shiftOctal
		je shiftOctal
		mov byte[cadena],30h
		
		add al,1h
		cmp al,5h
		jl otroCompletarOctal
salirCompletarOctal:
		lea dx,[msj]
		call imprimirMensaje
		ret


;**********************************************************************
; Imprimo un enter en la pantalla
;**********************************************************************
imprimirEnter:
		mov dx,salto
		mov ah,9h
		int 21h
		ret
		
;**********************************************************************
; Imprimo mensaje
;**********************************************************************
imprimirMensaje:
		mov ah,9
		int 21h
		call imprimirEnter
		ret