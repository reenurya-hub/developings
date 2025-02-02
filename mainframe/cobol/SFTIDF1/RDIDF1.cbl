       IDENTIFICATION DIVISION.
      * READS AN INDEXED FILE USING EITHER
       PROGRAM-ID. RDIDF1.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT LFIDPROVS ASSIGN TO "IDFPROVS.DAT"
        FILE STATUS IS FILE-CHECK-KEY
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS PROV-ID
        ALTERNATE RECORD KEY IS PROV-DESC
            WITH DUPLICATES.
        
       DATA DIVISION.
       FILE SECTION.
       FD LFIDPROVS.
       01 PROVS-RECORD.
           88 ENDOFFILE       VALUE HIGH-VALUES.
           03 PROV-ID             PIC 9(10).
           03 PROV-DESC           PIC X(40).
           03 PROV-BAL            PIC 9(10).
       
	   WORKING-STORAGE SECTION.
	   01  WS-WORK-AREAS.
	       05  FILE-CHECK-KEY      PIC X(2).
		       88 RECORDFOUND      VALUE "00".
			   
		   05  READTYPE            PIC 9.
		       88 PROVIDKEY     VALUE 1.
			   88 PROVDESCKEY    VALUE 2.
               88 ALLPROVS        VALUE 3.
			   
	       05  PRINTRECORD.
               10  PROVID          PIC 9(10).
               10  PROVDESC        PIC X(40).
       
       
       
       
       PROCEDURE DIVISION.
       
       0100-START.
       	   OPEN INPUT LFIDPROVS.
		   DISPLAY "SELECT RECORD BY PROV CODE, ENTER 1". 
		   DISPLAY "SELECT RECORD BY DESCRIPTION, ENTER 2".
			  
		   ACCEPT READTYPE.
		   
		   IF PROVIDKEY 
		      DISPLAY "ENTER PROV CODE KEY (10 DIGITS): " 
			    WITH NO ADVANCING		    
			  ACCEPT PROV-ID
			  READ LFIDPROVS
			    KEY IS PROV-ID
			    INVALID KEY DISPLAY "PROV STATUS: ",
				  FILE-CHECK-KEY
			  END-READ			 
           END-IF	

           IF PROVDESCKEY
		      DISPLAY "ENTER DESC PROV (40 CHARACTERS): " 
			    WITH NO ADVANCING
			  ACCEPT PROV-DESC
              READ LFIDPROVS
                KEY IS PROV-DESC			  
                INVALID KEY DISPLAY "PROV STATUS: ",
				  FILE-CHECK-KEY
              END-READ
			END-IF.

			IF RECORDFOUND
			   MOVE PROV-ID TO PROVID
			   MOVE PROV-DESC TO PROVDESC
			   DISPLAY PRINTRECORD
			END-IF.
			
			
		   PERFORM 9000-END-PROGRAM.
       
       
       9000-END-PROGRAM.
           CLOSE LFIDPROVS.
           STOP RUN.
       
       END PROGRAM RDIDF1.
