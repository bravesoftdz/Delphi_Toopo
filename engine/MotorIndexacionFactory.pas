//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
//
// Unidad: MotorIndexacionFactory.pas
//
// Prop�sito:
//		La clase TMotorIndexacionFactory proporciona m�todos para crear objetos de
//		alg�n tipo derivado de TMotorIndexacion a partir de un nombre de archivo.
//		Con el uso de esta clase conseguimos que quien necesite crear alg�n motor
//		de indexaci�n, no tenga que "usar" (meter en la clausula uses) la unidad
//		correspondiente al motor que necesita usar.
//		Esta clase sigue el patr�n "Builder" del GoF.
//
//
// Autor:          JM - http://www.lawebdejm.com
// Observaciones:  Creado en Delphi 6 para Todo Programaci�n (www.iberprensa.com)
// Copyright:      Este c�digo es de dominio p�blico y se puede utilizar y/o
//						 mejorar siempre que SE HAGA REFERENCIA AL AUTOR ORIGINAL, ya
//						 sea a trav�s de estos comentarios o de cualquier otro modo.
//
// Modificaciones:
//		JM		01/12/2004		Versi�n inicial
//		JM		12/01/2005		Ahora para definir un nuevo tipo de motor solo hay
//									que a�adir una nueva entrada en las constantes
//									EXTENSIONES_MOTOR y NOMBRES_MOTOR.
//
//~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
unit MotorIndexacionFactory;

interface


uses MotorIndexacion, EstadisticasIndexacion;


type
	TTipoMotorIndexacion = (tmDesconocido, tmASCII, tmHTML);

	TMotorIndexacionFactory = class(TObject)
	private
		class function GetTipoMotor(const archivo: string): TTipoMotorIndexacion;
	public
		class function CreateMotorIndexacion(const archivo, ficheroVacias, ficheroDiccionario: string; lenMinima: integer; estadisticas: TEstadisticasIndexacion = nil): TMotorIndexacion;
		class function GetFiltroSoportados: string;
	end;


implementation

uses SysUtils, MotorIndexacionASCII, MotorIndexacionHTML;

type
	TExtensionMotor = record
		tipoMotor: TTipoMotorIndexacion;
		extension: PChar;
	end;

	TNombreMotor = record
		tipoMotor: TTipoMotorIndexacion;
		nombre: PChar;
	end;

const
	MAX_EXTENSIONES_MOTOR = 4;

	EXTENSIONES_MOTOR : array[0..MAX_EXTENSIONES_MOTOR-1] of TExtensionMotor =
		(
			(tipoMotor: tmASCII;	extension: 'txt'),
			(tipoMotor: tmHTML;	extension: 'htm'),
			(tipoMotor: tmHTML;	extension: 'html'),
			(tipoMotor: tmHTML;	extension: 'xhtml')
		);


	MAX_NOMBRES_MOTOR = 2;

	NOMBRES_MOTOR : array[0..MAX_NOMBRES_MOTOR-1] of TNombreMotor =
		(
			(tipoMotor: tmASCII;	nombre: 'Archivos de texto'),
			(tipoMotor: tmHTML;	nombre: 'P�ginas web')
		);


class function TMotorIndexacionFactory.GetTipoMotor(const archivo: string): TTipoMotorIndexacion;
var
	punto: PChar;
	ext: array[0..63] of char;
	i: integer;
	encontrado: integer;
begin
	punto := StrRScan(PChar(archivo), '.');

	result := tmDesconocido;

	if punto <> nil then
	begin
		Inc(punto);
		StrCopy(ext, punto);

		encontrado := -1;
		i := Low(EXTENSIONES_MOTOR);
		while (encontrado = -1) and (i <= High(EXTENSIONES_MOTOR)) do
		begin
			if StrIComp(EXTENSIONES_MOTOR[i].extension, ext) = 0 then
				encontrado := i;
			Inc(i);
		end;

		if encontrado <> -1 then
			result := EXTENSIONES_MOTOR[encontrado].tipoMotor;
	end;
end;


class function TMotorIndexacionFactory.CreateMotorIndexacion(const archivo, ficheroVacias, ficheroDiccionario: string; lenMinima: integer; estadisticas: TEstadisticasIndexacion = nil): TMotorIndexacion;
var
	tipo: TTipoMotorIndexacion;
begin
	tipo := GetTipoMotor(archivo);
	case tipo of

		tmASCII:
			result := TMotorIndexacionASCII.Create(ficheroVacias, ficheroDiccionario, lenMinima, estadisticas);

		tmHTML:
			result := TMotorIndexacionHTML.Create(ficheroVacias, ficheroDiccionario, lenMinima, estadisticas);

		tmDesconocido:
			result := nil;
		else
			result := nil;
	end;
end;


class function TMotorIndexacionFactory.GetFiltroSoportados: string;
var
	iNombre: integer;

	procedure ConcatenarListaExtensiones(tipoMotor: TTipoMotorIndexacion; var cadena: string);
	var
		iExt: integer;
	begin
		for iExt:=Low(EXTENSIONES_MOTOR) to High(EXTENSIONES_MOTOR) do
			if EXTENSIONES_MOTOR[iExt].tipoMotor = tipoMotor then
				result := result + '*.' + EXTENSIONES_MOTOR[iExt].extension + ';';

		// quitar el ; final
		Delete(result, Length(result), 1);
	end;
begin
	// El formato de la cadena de filtro es el siguiente:
	//  Tipo archivo 1 (*.ext1;*.ext2)|*.ext1;*.ext2|
	//  Tipo archivo 2 (*.ext3)|*.ext3|
	//  Todos los archivos (*.*)|*.*

	for iNombre:=Low(NOMBRES_MOTOR) to High(NOMBRES_MOTOR) do
	begin
		// nombre
		result := result + NOMBRES_MOTOR[iNombre].nombre + ' (';

		// primera lista de extensiones (entre par�ntesis)
		ConcatenarListaExtensiones(NOMBRES_MOTOR[iNombre].tipoMotor, result);

		result := result + ')|';

		// segunda lista de extensiones
		ConcatenarListaExtensiones(NOMBRES_MOTOR[iNombre].tipoMotor, result);

		result := result + '|';
	end;

	// final del filtro
	result := result + 'Todos los archivos (*.*)|*.*';
end;


end.


