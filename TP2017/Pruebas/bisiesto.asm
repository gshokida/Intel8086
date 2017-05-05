segment datos data
		; Para el enter
		salto 			db 13,10,'$'
		
		; Fecha en Juliana con valores numericos
		j_anio          resw 1
		
		g_anio          dw 1900
		
		
		; Verificar si es bisiesto
		b_cuatrocientos dw 400
		b_cien          dw 100
		b_cuatro		dw 4
		esBisiesto      resb 1
		
		cociente		db  0
		resto			db  0
		
		
		msjEsBisiesto   db 'Es Bisiesto !$'
		msjNoEsBisiesto db 'No Es Bisiesto !!!!$'
		
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
		
hardcode:
		mov	word[j_anio],0
		
		mov word[g_anio],1900
		
		mov si,[j_anio]
		add word[g_anio],si

		call esAnioBisiesto
		
		cmp byte[esBisiesto],0
		je noEsBisiesto
		lea dx,[msjEsBisiesto]
		call imprimirMensaje
		jmp finPrograma
		
noEsBisiesto:
		lea dx,[msjNoEsBisiesto]
		call imprimirMensaje

finPrograma:
		mov ah,4Ch
		int 21h
		
		
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