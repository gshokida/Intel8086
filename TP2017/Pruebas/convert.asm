segment datos data
		; Mensajes
		msjInicial		db 'Comenzando el proceso de conversiones...$'
		msjFinal		db 'Fin del proceso de conversiones$'
		
		; Para el enter
		salto 			db 13,10,'$'
		
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
		auxdia          dw 1
		
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
		cociente		db  0
		resto			db  0
		
		
segment pila stack
		resb 1024
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

hardcode:
		mov	word[j_dias],40
		mov	word[j_anio],150

procesoConversion:
		call convertirAGregoriano
		
		; Imprimo la fecha en consola
		lea dx,[dia]
		call imprimirMensaje
		
finPrograma:
		call imprimirMensajeFinal
		mov ah,1
		int 21h
		mov ah,4Ch
		int 21h

		
;**********************************************************************
; Convierto de Juliano a Gregoriano y lo imprimo
;**********************************************************************	
convertirAGregoriano:
		mov si,[j_dias]
		mov [g_dia],si
		mov byte[g_mes],0
		mov word[g_anio],1900
		
		; utilizo si para moverme por el vector de dias por mes
		mov si,0
		mov byte[contador],0
		
siguienteMes:
		inc byte[g_mes]
		inc byte[contador]
		
		mov ax,0
		mov ax,[g_dia]
		cmp di,word[diasMes+si]
		jle finalizarContadorMes
		sub di,word[diasMes+si]
		mov [g_dia],di
		inc si
		inc si
		cmp byte[contador],12
		jge finalizarContadorMes
		jmp siguienteMes
		
finalizarContadorMes:
		mov si,[j_anio]
		add word[g_anio],si
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
; Inicializo el vector de dias por mes 
;**********************************************************************	
inicializarVariables:
		mov	word[diasMes],31
		mov	word[diasMes+1],28
		mov	word[diasMes+2],31
		mov	word[diasMes+3],30
		mov	word[diasMes+4],31
		mov	word[diasMes+5],30
		mov	word[diasMes+6],31
		mov	word[diasMes+7],31
		mov	word[diasMes+8],30
		mov	word[diasMes+9],31
		mov	word[diasMes+10],30
		mov	word[diasMes+11],31
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