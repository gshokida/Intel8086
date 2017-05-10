segment datos data

		;el nombre del archivo debe terminar con un 0 binario
		archivo   		db 'datos.dat' 
		                db 0
						
		fHandle			resw	1
		
		; Para el enter
		salto 			db 13,10,'$'
		
		; Para leer desde el archivo
		registro 		times 2 resb 1
		
		; Mensajes de manejo de archivos
		msjErrOpen		db 'Error en apertura$'
		msjErrRead		db 'Error en lectura$'
		msjErrClose		db 'Error en cierre$'
		
		; Numero binario
		total			dw 0
		numeroBinario   db 0
		
		;Multiplicadores
		PrimerDigito    dw 1
		SegundoDigito   dw 10
		TercerDigito   	dw 100
		
		;Dia en formato string
		dia 			times 3 db '0'
						db '$'
		
		; Para realizar la conversion a string
		diez			dw  10
		
		; Para mostrar la fecha en la consola
		convertNum		times 4 db '0'
		                db '$'
		
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
		
abrirArchivo:
		mov dx,archivo			;dx = dir del nombre del archivo
		mov ah,3dh				;ah = servicio para abrir archivo 3dh
		mov al,0				;al = tipo de acceso (0=lectura; 1=escritura; 2=lectura y escritura)
		int 21h
		jc	errOpen
		mov	[fHandle],ax		; en ax queda el handle del archivo

obtenerRegistro:
		mov bx,[fHandle]		;bx = handle del archivo
		mov cx,2				;cx = cantidad de bytes a escribir
		mov ah,3fh				;ah = servicio para leer desde un archivo: 3fh
		mov dx,registro			;dx = dir del area de memoria q contiene los bytes leidos del archivo
		int 21h
		jc	errRead
		cmp ax,0			;ax = cantidad de bytes leidos
        je cierroArchivo	;si la cantidad de bytes leidos es 0 termine de leer el archivo
		
		call convertirADecimal
		
		jmp obtenerRegistro
		
cierroArchivo:
		mov bx,[fHandle]		;bx = handle del archivo
		mov ah,3eh				;ah = servicio para cerrar archivo: 3eh
		int 21h
		jc	errClose
		
		mov ah,1
		int 21h
		
finPrograma:
		mov ah,4Ch
		int 21h

		
convertirADecimal:
		;contador en cero
		mov word[total],0
		
		;cargo el valor del empaquetado
		mov dx,word[registro]
		shr dh,4
		mov byte[numeroBinario],dh
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[PrimerDigito]
		mov word[total],ax
		
		;Segundo digito
		mov dx,word[registro]
		shl dl,4
		shr dl,4
		mov byte[numeroBinario],dl
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[SegundoDigito]
		add word[total],ax
		
		;Segundo digito
		mov dx,word[registro]
		shr dl,4
		mov byte[numeroBinario],dl
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[TercerDigito]
		add word[total],ax
		
		;Convertir a string
		mov  dx,0
		mov  ax,word[total]
		mov  si,2
		call divisionesSucesivas
		mov al,[convertNum]
		mov [dia],al
		mov al,[convertNum+1]
		mov [dia+1],al
		mov al,[convertNum+2]
		mov [dia+2],al
		
		; Imprimo la fecha en consola
		lea dx,[dia]
		call imprimirMensaje
		
		ret
		
divisionesSucesivas:
		div  word[diez]      		;dx:ax div 10 ==> dx <- resto & ax <- cociente
		add  dx,48		      		;convierto a Ascii el resto
		mov  [convertNum+si],dl	 	;lo pongo en la posicion anterior
		sub  si,1		      		;posiciono SI en el caracter anterior en la cadena
		cmp  ax,[diez]				;IF    cociente < 10
		jl   finDivision			;THEN  fin division
		mov  dx,0					;pongo en 0 DX para la dupla DX:AX
		jmp  divisionesSucesivas
finDivision:
		add  ax,48
		mov  [convertNum+si],al
		ret
		
;**********************************************************************
; Imprimo errores con manejo de archivos
;**********************************************************************
errOpen:
	lea dx,[msjErrOpen]
	call imprimirMensaje
	jmp	finPrograma
	
errRead:
	lea dx,[msjErrRead]
	call imprimirMensaje
	jmp cierroArchivo
	
errClose:
	lea dx,[msjErrClose]
	call imprimirMensaje
	jmp finPrograma
	
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