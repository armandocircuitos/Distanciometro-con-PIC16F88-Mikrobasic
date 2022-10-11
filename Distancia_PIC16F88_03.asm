
_ping_HC_SR04:

;Distancia_PIC16F88_03.mbas,11 :: 		dim dista as byte
;Distancia_PIC16F88_03.mbas,12 :: 		TMR1H = 0xB1
	MOVLW      177
	MOVWF      TMR1H+0
;Distancia_PIC16F88_03.mbas,13 :: 		TMR1L = 0xDF
	MOVLW      223
	MOVWF      TMR1L+0
;Distancia_PIC16F88_03.mbas,14 :: 		PortA.6 = 0  'trigger
	BCF        PORTA+0, 6
;Distancia_PIC16F88_03.mbas,15 :: 		Delay_us(2)
	NOP
	NOP
	NOP
	NOP
;Distancia_PIC16F88_03.mbas,16 :: 		PortA.6 = 1  'trigger
	BSF        PORTA+0, 6
;Distancia_PIC16F88_03.mbas,17 :: 		Delay_us(10)
	MOVLW      6
	MOVWF      R13+0
L__ping_HC_SR041:
	DECFSZ     R13+0, 1
	GOTO       L__ping_HC_SR041
	NOP
;Distancia_PIC16F88_03.mbas,18 :: 		PortA.6 = 0   'trigger
	BCF        PORTA+0, 6
;Distancia_PIC16F88_03.mbas,19 :: 		while(PortA.7=0)wend  'Echo
L__ping_HC_SR043:
	BTFSS      PORTA+0, 7
	GOTO       L__ping_HC_SR043
;Distancia_PIC16F88_03.mbas,20 :: 		T1CON.TMR1ON=1
	BSF        T1CON+0, 0
;Distancia_PIC16F88_03.mbas,21 :: 		while((PortA.7=1)AND(PIR1.TMR1IF=0))wend 'Echo
L__ping_HC_SR048:
	BTFSC      PORTA+0, 7
	GOTO       L__ping_HC_SR0428
	BCF        116, 0
	GOTO       L__ping_HC_SR0429
L__ping_HC_SR0428:
	BSF        116, 0
L__ping_HC_SR0429:
	BTFSC      PIR1+0, 0
	GOTO       L__ping_HC_SR0430
	BSF        3, 0
	GOTO       L__ping_HC_SR0431
L__ping_HC_SR0430:
	BCF        3, 0
L__ping_HC_SR0431:
	BTFSS      116, 0
	GOTO       L__ping_HC_SR0432
	BTFSS      3, 0
	GOTO       L__ping_HC_SR0432
	BSF        116, 0
	GOTO       L__ping_HC_SR0433
L__ping_HC_SR0432:
	BCF        116, 0
L__ping_HC_SR0433:
	BTFSC      116, 0
	GOTO       L__ping_HC_SR048
;Distancia_PIC16F88_03.mbas,22 :: 		T1CON.TMR1ON =0
	BCF        T1CON+0, 0
;Distancia_PIC16F88_03.mbas,23 :: 		PIR1.TMR1IF=0
	BCF        PIR1+0, 0
;Distancia_PIC16F88_03.mbas,24 :: 		CONTH=TMR1H
	MOVF       TMR1H+0, 0
	MOVWF      _CONTH+0
	CLRF       _CONTH+1
;Distancia_PIC16F88_03.mbas,25 :: 		CONTL=TMR1L
	MOVF       TMR1L+0, 0
	MOVWF      _CONTL+0
	CLRF       _CONTL+1
;Distancia_PIC16F88_03.mbas,26 :: 		CONTH=CONTH << 8
	MOVF       _CONTH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	MOVWF      _CONTH+0
	MOVF       R0+1, 0
	MOVWF      _CONTH+1
;Distancia_PIC16F88_03.mbas,27 :: 		CONTH=CONTH AND 0XFF00
	MOVLW      0
	ANDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	ANDLW      255
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      _CONTH+0
	MOVF       R2+1, 0
	MOVWF      _CONTH+1
;Distancia_PIC16F88_03.mbas,28 :: 		CONTL=CONTL AND 0x00FF
	MOVLW      255
	ANDWF      _CONTL+0, 0
	MOVWF      R0+0
	MOVF       _CONTL+1, 0
	MOVWF      R0+1
	MOVLW      0
	ANDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _CONTL+0
	MOVF       R0+1, 0
	MOVWF      _CONTL+1
;Distancia_PIC16F88_03.mbas,29 :: 		CONTH=CONTH OR CONTL
	MOVF       R2+0, 0
	IORWF      R0+0, 1
	MOVF       R2+1, 0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _CONTH+0
	MOVF       R0+1, 0
	MOVWF      _CONTH+1
;Distancia_PIC16F88_03.mbas,30 :: 		result = CONTH
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
	MOVLW      0
	BTFSC      R5+1, 7
	MOVLW      255
	MOVWF      R5+2
	MOVWF      R5+3
;Distancia_PIC16F88_03.mbas,31 :: 		end sub
	MOVF       R5+0, 0
	MOVWF      R0+0
	MOVF       R5+1, 0
	MOVWF      R0+1
	MOVF       R5+2, 0
	MOVWF      R0+2
	MOVF       R5+3, 0
	MOVWF      R0+3
L_end_ping_HC_SR04:
	RETURN
; end of _ping_HC_SR04

_TIMER1_INI:

;Distancia_PIC16F88_03.mbas,33 :: 		sub procedure TIMER1_INI()
;Distancia_PIC16F88_03.mbas,34 :: 		PIR1.TMR1IF=0
	BCF        PIR1+0, 0
;Distancia_PIC16F88_03.mbas,35 :: 		PIE1.TMR1IE=0
	BCF        PIE1+0, 0
;Distancia_PIC16F88_03.mbas,36 :: 		T1CON.TMR1CS=0
	BCF        T1CON+0, 1
;Distancia_PIC16F88_03.mbas,37 :: 		T1CON.T1CKPS1=T1CON.T1CKPS0=0
	BTFSC      T1CON+0, 4
	GOTO       L__TIMER1_INI35
	BSF        T1CON+0, 5
	GOTO       L__TIMER1_INI36
L__TIMER1_INI35:
	BCF        T1CON+0, 5
L__TIMER1_INI36:
;Distancia_PIC16F88_03.mbas,38 :: 		end sub
L_end_TIMER1_INI:
	RETURN
; end of _TIMER1_INI

_main:

;Distancia_PIC16F88_03.mbas,41 :: 		main:
;Distancia_PIC16F88_03.mbas,42 :: 		ADCON0 = 0
	CLRF       ADCON0+0
;Distancia_PIC16F88_03.mbas,43 :: 		ANSEL = 0
	CLRF       ANSEL+0
;Distancia_PIC16F88_03.mbas,44 :: 		CMCON = 7
	MOVLW      7
	MOVWF      CMCON+0
;Distancia_PIC16F88_03.mbas,45 :: 		TRISA = 0xB8
	MOVLW      184
	MOVWF      TRISA+0
;Distancia_PIC16F88_03.mbas,46 :: 		TRISB = 0x00
	CLRF       TRISB+0
;Distancia_PIC16F88_03.mbas,47 :: 		PORTA = 0x00
	CLRF       PORTA+0
;Distancia_PIC16F88_03.mbas,48 :: 		PORTB = 0x00
	CLRF       PORTB+0
;Distancia_PIC16F88_03.mbas,50 :: 		CONTH=0
	CLRF       _CONTH+0
	CLRF       _CONTH+1
;Distancia_PIC16F88_03.mbas,51 :: 		CONTL=0
	CLRF       _CONTL+0
	CLRF       _CONTL+1
;Distancia_PIC16F88_03.mbas,52 :: 		TIMER1_INI()
	CALL       _TIMER1_INI+0
;Distancia_PIC16F88_03.mbas,53 :: 		Delay_ms(5)
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L__main14:
	DECFSZ     R13+0, 1
	GOTO       L__main14
	DECFSZ     R12+0, 1
	GOTO       L__main14
	NOP
	NOP
;Distancia_PIC16F88_03.mbas,55 :: 		promedio = 0
	CLRF       _promedio+0
	CLRF       _promedio+1
;Distancia_PIC16F88_03.mbas,56 :: 		cnt = 0
	CLRF       _cnt+0
;Distancia_PIC16F88_03.mbas,57 :: 		aux = 0
	CLRF       _aux+0
	CLRF       _aux+1
;Distancia_PIC16F88_03.mbas,58 :: 		unidad = 0
	CLRF       _unidad+0
	CLRF       _unidad+1
;Distancia_PIC16F88_03.mbas,59 :: 		decena = 0
	CLRF       _decena+0
	CLRF       _decena+1
;Distancia_PIC16F88_03.mbas,60 :: 		centena = 0
	CLRF       _centena+0
	CLRF       _centena+1
;Distancia_PIC16F88_03.mbas,61 :: 		residuos = 0
	CLRF       _residuos+0
	CLRF       _residuos+1
;Distancia_PIC16F88_03.mbas,63 :: 		numero[0] = 0xBF
	MOVLW      191
	MOVWF      _numero+0
	CLRF       _numero+1
;Distancia_PIC16F88_03.mbas,64 :: 		numero[1] = 0x86
	MOVLW      134
	MOVWF      _numero+2
	CLRF       _numero+3
;Distancia_PIC16F88_03.mbas,65 :: 		numero[2] = 0xDB
	MOVLW      219
	MOVWF      _numero+4
	CLRF       _numero+5
;Distancia_PIC16F88_03.mbas,66 :: 		numero[3] = 0xCF
	MOVLW      207
	MOVWF      _numero+6
	CLRF       _numero+7
;Distancia_PIC16F88_03.mbas,67 :: 		numero[4] = 0xE6
	MOVLW      230
	MOVWF      _numero+8
	CLRF       _numero+9
;Distancia_PIC16F88_03.mbas,68 :: 		numero[5] = 0xED
	MOVLW      237
	MOVWF      _numero+10
	CLRF       _numero+11
;Distancia_PIC16F88_03.mbas,69 :: 		numero[6] = 0xFD
	MOVLW      253
	MOVWF      _numero+12
	CLRF       _numero+13
;Distancia_PIC16F88_03.mbas,70 :: 		numero[7] = 0x87
	MOVLW      135
	MOVWF      _numero+14
	CLRF       _numero+15
;Distancia_PIC16F88_03.mbas,71 :: 		numero[8] = 0xFF
	MOVLW      255
	MOVWF      _numero+16
	CLRF       _numero+17
;Distancia_PIC16F88_03.mbas,72 :: 		numero[9] = 0xEF
	MOVLW      239
	MOVWF      _numero+18
	CLRF       _numero+19
;Distancia_PIC16F88_03.mbas,74 :: 		While true
L__main16:
;Distancia_PIC16F88_03.mbas,75 :: 		dist=ping_HC_SR04()
	CALL       _ping_HC_SR04+0
	MOVF       R0+0, 0
	MOVWF      _dist+0
	MOVF       R0+1, 0
	MOVWF      _dist+1
;Distancia_PIC16F88_03.mbas,76 :: 		dist = ((dist-45535) / 29) '  /29)/2
	MOVLW      223
	SUBWF      R0+0, 1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVLW      177
	SUBWF      R0+1, 1
	MOVLW      29
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _dist+0
	MOVF       R0+1, 0
	MOVWF      _dist+1
;Distancia_PIC16F88_03.mbas,77 :: 		Delay_ms(1)
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L__main20:
	DECFSZ     R13+0, 1
	GOTO       L__main20
	DECFSZ     R12+0, 1
	GOTO       L__main20
	NOP
	NOP
;Distancia_PIC16F88_03.mbas,80 :: 		residuos = promedio
	MOVF       _promedio+0, 0
	MOVWF      _residuos+0
	MOVF       _promedio+1, 0
	MOVWF      _residuos+1
;Distancia_PIC16F88_03.mbas,81 :: 		unidad=residuos mod 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _promedio+0, 0
	MOVWF      R0+0
	MOVF       _promedio+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _unidad+0
	MOVF       R0+1, 0
	MOVWF      _unidad+1
;Distancia_PIC16F88_03.mbas,82 :: 		residuos=residuos / 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _residuos+0, 0
	MOVWF      R0+0
	MOVF       _residuos+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _residuos+0
	MOVF       R0+1, 0
	MOVWF      _residuos+1
;Distancia_PIC16F88_03.mbas,83 :: 		decena=residuos mod 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _decena+0
	MOVF       R0+1, 0
	MOVWF      _decena+1
;Distancia_PIC16F88_03.mbas,84 :: 		residuos=residuos / 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _residuos+0, 0
	MOVWF      R0+0
	MOVF       _residuos+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _residuos+0
	MOVF       R0+1, 0
	MOVWF      _residuos+1
;Distancia_PIC16F88_03.mbas,85 :: 		centena=residuos mod 10
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _centena+0
	MOVF       R0+1, 0
	MOVWF      _centena+1
;Distancia_PIC16F88_03.mbas,87 :: 		PORTB=numero[unidad]
	MOVF       _unidad+0, 0
	MOVWF      R0+0
	MOVF       _unidad+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _numero+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTB+0
;Distancia_PIC16F88_03.mbas,88 :: 		PORTA=0x03
	MOVLW      3
	MOVWF      PORTA+0
;Distancia_PIC16F88_03.mbas,89 :: 		delay_ms(5)
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L__main21:
	DECFSZ     R13+0, 1
	GOTO       L__main21
	DECFSZ     R12+0, 1
	GOTO       L__main21
	NOP
	NOP
;Distancia_PIC16F88_03.mbas,90 :: 		PORTA=0xff
	MOVLW      255
	MOVWF      PORTA+0
;Distancia_PIC16F88_03.mbas,91 :: 		PORTB=numero[decena]
	MOVF       _decena+0, 0
	MOVWF      R0+0
	MOVF       _decena+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _numero+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTB+0
;Distancia_PIC16F88_03.mbas,92 :: 		PORTA=0x05
	MOVLW      5
	MOVWF      PORTA+0
;Distancia_PIC16F88_03.mbas,93 :: 		delay_ms(5)
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L__main22:
	DECFSZ     R13+0, 1
	GOTO       L__main22
	DECFSZ     R12+0, 1
	GOTO       L__main22
	NOP
	NOP
;Distancia_PIC16F88_03.mbas,94 :: 		PORTA=0x0f
	MOVLW      15
	MOVWF      PORTA+0
;Distancia_PIC16F88_03.mbas,95 :: 		PORTB=numero[centena]
	MOVF       _centena+0, 0
	MOVWF      R0+0
	MOVF       _centena+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _numero+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTB+0
;Distancia_PIC16F88_03.mbas,96 :: 		PORTA=0x06
	MOVLW      6
	MOVWF      PORTA+0
;Distancia_PIC16F88_03.mbas,97 :: 		delay_ms(5)
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L__main23:
	DECFSZ     R13+0, 1
	GOTO       L__main23
	DECFSZ     R12+0, 1
	GOTO       L__main23
	NOP
	NOP
;Distancia_PIC16F88_03.mbas,98 :: 		PORTA=0x0f
	MOVLW      15
	MOVWF      PORTA+0
;Distancia_PIC16F88_03.mbas,100 :: 		cnt = cnt + 1
	INCF       _cnt+0, 1
;Distancia_PIC16F88_03.mbas,101 :: 		aux = aux + dist
	MOVF       _dist+0, 0
	ADDWF      _aux+0, 1
	MOVF       _dist+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _aux+1, 1
;Distancia_PIC16F88_03.mbas,102 :: 		if cnt > 5 then
	MOVLW      128
	XORLW      5
	MOVWF      R0+0
	MOVLW      128
	XORWF      _cnt+0, 0
	SUBWF      R0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main25
;Distancia_PIC16F88_03.mbas,103 :: 		promedio = aux / 6
	MOVLW      6
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _aux+0, 0
	MOVWF      R0+0
	MOVF       _aux+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _promedio+0
	MOVF       R0+1, 0
	MOVWF      _promedio+1
;Distancia_PIC16F88_03.mbas,104 :: 		cnt = 0
	CLRF       _cnt+0
;Distancia_PIC16F88_03.mbas,105 :: 		aux = 0
	CLRF       _aux+0
	CLRF       _aux+1
L__main25:
;Distancia_PIC16F88_03.mbas,108 :: 		wend
	GOTO       L__main16
L_end_main:
	GOTO       $+0
; end of _main
