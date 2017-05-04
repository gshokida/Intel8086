;*********************************************************************
; char2.asm
; Ejercicio que lee un caracter de teclado.  Si es alfanumerico lo imprime por pantalla,
; en caso contrario ipmrime un mensaje de error.
;
;*********************************************************************

segment pila	stack
      	  resb 64
segment datos data

	char		resb	1
	msgIng  db  	"Ingrese un caracter alfanumerico: $"
	msgMues db  	10,13,"Ud ingreso: $"
	msgErr	db  	10,13,"No ingreso un caracter alfanumerico!$"

segment codigo code
..start:
	mov	ax,datos		;ds <-- dir del segmento de datos
	mov	ds,ax
	mov	ax,pila		;ss <-- dir del segmento de pila
	mov	ss,ax

	lea	dx,[msgIng]	;dx <-- offset de 'msgIng' dento del segmento de datos
	mov	ah,9			;servicio 9 para int 21h -- Impmrimir msg en pantalla
	int	21h

	mov	ah,8			   ;servicio 8 para int 21h -- Lee caracter de teclado, lo deja en 'al'
	int	21h
	mov	[char],al		;guardo en char el ascii

	cmp	byte[char],'0'	; char < 0 => error
	jb    error

	cmp	byte[char],'9'	; char <= 9 => ok
	jbe	ok

	cmp	byte[char],'A'	; char < A => error
	jb    error
	
	cmp	byte[char],'Z'	; char <= Z => ok
	jbe	ok

	cmp	byte[char],'a'	; char < a => error
	jb    error
	
	cmp	byte[char],'z'	; char <= z => ok
	jbe	ok

error:
	lea	dx,[msgErr]	; Imprimo msg de error
	mov	ah,9
	int	21h
	jmp	fin		; me voy al fin

ok:
	mov	dx,msgMues	; Imprimo msg de ok
	mov	ah,9
	int	21h

	mov	dl,[char]		; dl <-- caracter ascii a imprimir
	mov	ah,2		; servicio 2 para int 21h -- Imprime un caracter, que esta en 'dl'
	int	21h

fin:
;retorno al DOS
	mov	ax,4c00h
	int	21h
