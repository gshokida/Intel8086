segment datos data
		; Mensajes
		msjInicial		db 'Comenzando el proceso de conversiones...$'
		msjFinal		db 'Fin del proceso de conversiones$'
		msjErrOpen		db 'Error en apertura$'
		msjErrRead		db 'Error en lectura$'
		msjErrClose		db 'Error en cierre$'
		
		;el nombre del archivo debe terminar con un 0 binario
		archivo   		db 'fechas.dat' 
		                db 0
						
		fHandle			resw	1
		
		; Para el enter
		salto 			db 13,10,'$'
		
		; Para leer desde el archivo
		registro 		times 6 resb 1
		
		; Fecha en Juliana con valores numericos
		j_dias     		resw 1
		j_anio          resw 1
		
		; Vector de dias por Mes
		diasMes         times 12 resw 1
		
		; Para sumar al año en la fecha Juliana
		convertAnio     dw 1900
		
		; Fecha en Gregoriano con valores numericos
		g_dia           resw 1
		g_mes    		resw 1
		g_anio          dw 1900
		
		; Contador para iterar por mes
		contador 		db 1
		
		; Para mostrar la fecha en la consola
		convertNum		times 4 db '0'
		                db '$'
						
		dia    			times 2 db '0'
						db '/'
		mes    			times 2 db '0'
						db '/'
		anio    		times 4 db '0'
						db '$'
		
		; Para realizar la conversion a string
		diez			dw  10
		
		;Multiplicadores
		PrimerDigito    dw 1
		SegundoDigito   dw 10
		TercerDigito   	dw 100
		
		; Numero binario
		numeroBinario   db 0
		
		; Verificar si es bisiesto
		b_cuatrocientos dw 400
		b_cien          dw 100
		b_cuatro		dw 4
		esBisiesto      resb 1
		
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
		call imprimirMensajeInicio
		
		call inicializarVariables
		
abrirArchivo:
		mov dx,archivo			;dx = dir del nombre del archivo
		mov ah,3dh				;ah = servicio para abrir archivo 3dh
		mov al,0				;al = tipo de acceso (0=lectura; 1=escritura; 2=lectura y escritura)
		int 21h
		jc	errOpen
		mov	[fHandle],ax		; en ax queda el handle del archivo
		
obtenerRegistro:
		mov bx,[fHandle]		;bx = handle del archivo
		mov cx,6				;cx = cantidad de bytes a escribir
		mov ah,3fh				;ah = servicio para leer desde un archivo: 3fh
		mov dx,registro			;dx = dir del area de memoria q contiene los bytes leidos del archivo
		int 21h
		jc	errRead
		cmp ax,0				;ax = cantidad de bytes leidos
        je cierroArchivo		;si la cantidad de bytes leidos es 0 termine de leer el archivo
		
		call realizarCodificacion
		
		jmp obtenerRegistro
		
cierroArchivo:
		mov bx,[fHandle]		;bx = handle del archivo
		mov ah,3eh				;ah = servicio para cerrar archivo: 3eh
		int 21h
		jc	errClose
		call imprimirMensajeFinal
		mov ah,1
		int 21h
		
finPrograma:
		mov ah,4Ch
		int 21h


;**********************************************************************
; Luego de obtener el registro hago la codificacion de empaquetado a 
; binario
;**********************************************************************	
realizarCodificacion:
		call obtenerAnioDelRegistro
		call obtenerDiasDelRegistro
		
		call convertirAGregoriano
		
		; Imprimo la fecha en consola
		lea dx,[dia]
		call imprimirMensaje
		
		ret
		
obtenerAnioDelRegistro:
		;contador en cero
		mov word[j_anio],0
		
		mov dx,word[registro]
		shr dh,4
		mov byte[numeroBinario],dh
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[PrimerDigito]
		mov word[j_anio],ax
		
		;Segundo digito
		mov dx,word[registro]
		shl dl,4
		shr dl,4
		mov byte[numeroBinario],dl
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[SegundoDigito]
		add word[j_anio],ax
		
		;Segundo digito
		mov dx,word[registro]
		shr dl,4
		mov byte[numeroBinario],dl
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[TercerDigito]
		add word[j_anio],ax

		ret
		
obtenerDiasDelRegistro:
		;contador en cero
		mov word[j_dias],0
		
		mov dx,word[registro+4]
		shr dh,4
		mov byte[numeroBinario],dh
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[PrimerDigito]
		mov word[j_dias],ax
		
		;Segundo digito
		mov dx,word[registro+4]
		shl dl,4
		shr dl,4
		mov byte[numeroBinario],dl
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[SegundoDigito]
		add word[j_dias],ax
		
		;Segundo digito
		mov dx,word[registro+4]
		shr dl,4
		mov byte[numeroBinario],dl
		mov ax,0
		mov al,byte[numeroBinario]
		mul word[TercerDigito]
		add word[j_dias],ax
		
		ret
;**********************************************************************
; Convierto de Juliano a Gregoriano y lo imprimo
;**********************************************************************	
convertirAGregoriano:
		mov si,[j_dias]
		mov word[g_dia],si
		mov word[g_mes],0
		mov word[g_anio],1900
		
		; utilizo si para moverme por el vector de dias por mes
		mov byte[contador],0
		
		; calcular el año
		mov si,[j_anio]
		add word[g_anio],si
		
		call esAnioBisiesto
		cmp byte[esBisiesto],0
		je iniciarLoopMes
		
		; Si es año bisiesto febrero tiene 29 dias 
		mov	word[diasMes+2],29

iniciarLoopMes:
		mov si,0
		
siguienteMes:
		inc byte[g_mes]
		inc byte[contador]
		
		mov ax,0
		mov ax,word[g_dia]
		cmp ax,word[diasMes+si]
		jle finalizarContadorMes
		sub ax,word[diasMes+si]
		mov word[g_dia],ax
		inc si
		inc si
		cmp byte[contador],12
		jge finalizarContadorMes
		jmp siguienteMes
		
finalizarContadorMes:
		mov	word[diasMes+2],28
		call darFormatoString
		
		ret
		
;**********************************************************************
; Convierto a string la fecha para mostrar
;**********************************************************************
darFormatoString:
		; Obtengo el día
		mov  dx,0
		mov  ax,[g_dia]
		mov  si,1
		call divisionesSucesivas
		mov al,[convertNum]
		mov [dia],al
		mov al,[convertNum+1]
		mov [dia+1],al
		
		; Obtengo el mes
		mov  dx,0
		mov  ax,[g_mes]
		mov  si,1
		call divisionesSucesivas
		mov al,[convertNum]
		mov [mes],al
		mov al,[convertNum+1]
		mov [mes+1],al
		
		; Obtengo el año
		mov  dx,0
		mov  ax,[g_anio]
		mov  si,3
		call divisionesSucesivas
		mov al,[convertNum]
		mov [anio],al
		mov al,[convertNum+1]
		mov [anio+1],al
		mov al,[convertNum+2]
		mov [anio+2],al
		mov al,[convertNum+3]
		mov [anio+3],al
		
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
; Devuelve en esBisiesto 0 si no es bisiesto y 1 si es bisiesto
;**********************************************************************
esAnioBisiesto:
		mov byte[esBisiesto],0
		
		; si es divisible por 400 es bisiesto
		mov dx,0
		mov ax,[g_anio]
		div word[b_cuatrocientos]
		cmp dx,0
		je siEsAnioBisiesto
		
		; si es divisible 4, tengo que verificar que no es divisible por 100
		mov dx,0
		mov ax,[g_anio]
		div word[b_cuatro]
		cmp dx,0
		je verificarSiEsDivisiblePorCien
		ret
		
verificarSiEsDivisiblePorCien:
		mov dx,0
		mov ax,[g_anio]
		div word[b_cien]
		cmp dx,0
		jne siEsAnioBisiesto
		ret
		
siEsAnioBisiesto:
		mov byte[esBisiesto],1
		ret
		
;**********************************************************************
; Inicializo el vector de dias por mes 
;**********************************************************************	
inicializarVariables:
		mov	word[diasMes],31
		mov	word[diasMes+2],28
		mov	word[diasMes+4],31
		mov	word[diasMes+6],30
		mov	word[diasMes+8],31
		mov	word[diasMes+10],30
		mov	word[diasMes+12],31
		mov	word[diasMes+14],31
		mov	word[diasMes+16],30
		mov	word[diasMes+18],31
		mov	word[diasMes+20],30
		mov	word[diasMes+22],31
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
		
;**********************************************************************
; Imprimo mensaje de inicio
;**********************************************************************
imprimirMensajeInicio:
		lea dx,[msjInicial]
		call imprimirMensaje
		ret
		
;**********************************************************************
; Imprimo mensaje de inicio
;**********************************************************************
imprimirMensajeFinal:
		lea dx,[msjFinal]
		call imprimirMensaje
		ret