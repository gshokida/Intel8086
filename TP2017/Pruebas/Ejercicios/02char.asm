;*********************************************************************
; char.asm
; Ejercicio que lee un caracter de teclado y lo imprime por pantalla
;
;*********************************************************************
segment pila	stack
      	  resb 64
segment datos data
	char     resb	1
	msgIng  	db  	10,13,"Ingrese un caracter alfanumerico: $"
	msgMues 	db  	10,13,"Ud ingreso: $"

segment codigo code
..start:
	mov	ax,datos		;ds <-- dir del segmento de datos
	mov	ds,ax
	mov	ax,pila		;ss <-- dir del segmento de pila
	mov	ss,ax

	lea	dx,[msgIng]	;dx <-- offset de 'msgIng' dento del segmento de datos
	mov	ah,9			;servicio 9 para int 21h -- Impmrimir msg en pantalla
	int	21h

	mov	ah,8h			;servicio 8 para int 21h -- Lee caracter de teclado pero no lo muestra, lo deja en 'al'
   ;mov ah,1h			;servicio 1 para int 21h -- lee caracter de teclado y lo muestra, lo deja en 'al'
	int	21h

	mov	[char],al	;guardo en char el ascii del caracter ingresado ya que el servicio
                     ;que se ejecuta a continuación altera 'al' copiando el ascii del signo $
	mov	dx,msgMues	;dx <- offset de 'msgMues' dento del segmento de datos
	mov	ah,9			;servicio 9 para int 21h -- Impmrimir msg en pantalla
	int	21h

	mov	dl,[char]	; dl <- caracter ascii a imprimir
	mov	ah,2			; servicio 2 para int 21h -- Imprime un caracter, que esta en 'dl'
	int	21h

   ;Retorno al DOS
	mov	ax,4c00h
	int	21h
