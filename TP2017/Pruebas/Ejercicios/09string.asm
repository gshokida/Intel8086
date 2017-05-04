;******************************************************
; strings.asm
; Comparaciones y copias de strings
;******************************************************
segment pila stack
   resb 1024
segment datos data

msg1	db  "hola como estas?"
msg2	db  "hola como estas?"     ;para probar que la comparacion de igual
;msg2	db  "hola como andas?"     ;para probar que la comparacion de distinto
dist    db  "distintos$"
igua    db  "iguales$"

msg3    db  "01234$"
msg4	db  "56789$"

msg5	db  "ABCDE$"
msg6	db  "FGHIJ$"

segment codigo code
..start:
	mov	ax,datos
	mov	ds,ax		;ds <-- dir del segmento de datos
	mov	es,ax		;es <-- dir del segmento de datos 
                  ;lo usan las instucciones para apuntar al string de destino jutno con el reg DI

	;*********************
	;COMPARACION CON CMPSB
	;*********************
	;comparo msg1 y msg 2 con CMPSB (de a un byte)
	mov	cx,16		; cx = cantidad de bytes a comparar
	lea	si,[msg1]		; si = dir msg1
	lea	di,[msg2]		; di = dir msg2
repe	cmpsb
	je	IGUALES

	mov	dx,dist	; imprimo mensaje "distintos"
	call	printMsg
	jmp	COMPAW
         ;jmp      fin
IGUALES:
	mov	dx,igua	; imprimo mensaje "iguales"
	call	printMsg


	;*********************
	;COMPARACION CON CMPSW
	;*********************
COMPAW:
	;ahora comparo msg1 y msg 2 con COMSW (de a 2 bytes)
	mov	cx,8		; cx = cantidad de duplas de bytes a comparar. Si pongo algo <=5 da Iguales
	lea	si,[msg1]		; si = dir msg1
	lea	di,[msg2]		; di = dir msg2
repe	cmpsw
	je	IGUALES2

	lea	dx,[dist]	; imprimo mensaje "distintos"
	call	printMsg
	jmp	COPIA
IGUALES2:
	lea	dx,[igua]	; imprimo mensaje "iguales"
	call	printMsg
	

	;***************
	;COPIA CON MOVSB
	;***************
	;copio un string a otro con MOVSB (de a 1 byte)
COPIA:
	mov	cx,4		;cx = cantidad de bytes a copiar
	lea	si,[msg4]		;si = dir string origen
	lea	di,[msg3]		;di = dir string destino
rep	movsb
	lea	dx,[msg3]
	call	printMsg

	;***************
	;COPIA CON MOVSW
	;***************
	;ahora copio con MOVSW (de a 2 bytes)
	mov	cx,2		;cx = cantidad duplas de bytes a copiar
	lea	si,[msg6]
	lea	di,[msg5]
rep	movsw
	lea	dx,[msg5]
	call	printMsg
fin:
	mov  ax,4c00h  ; retornar al DOS
	int  21h
	
;*************************************Rutinas*******************************************
printMsg:
	mov	ah,9  ; servicio 9 para int 21 -- Impmrimir cadena en pantalla
	int	21h
	ret
;***************************************************************************************
