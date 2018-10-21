program KiotoSistem;

// Para el uso de limpiar pantalla
uses Crt;

{
	Declaracion de Constantes
}

const
	
	// Cant. maxima de productos 
	max_fila = 50;


{
	Declaracion de Tipos de Registros
}

type

	Producto = record

		codigo: String[10];
		nombre: String[30];
		descripcion: String[30];
		cantidad: Integer;
		precio: Integer;
		
	end;

	Cliente = record

		nombre: String[30];
		apellido: String[30];
		cedula: String[8];
		direccion: String[30];
		
	end;

	Factura = record

		codigo: Integer;
		codigoProd: String[10];
		nombreC: String[30];
		apellidoC: String[30];
		cedulaC: String[30];
		direccionC: String[30];
		dia: Integer;
		mes: Integer;
		anno: Integer;
		cantidadProd: Integer;
		montoProd: Integer;

	end;

	// Almacena solo cadenas de caracteres de un inventario (codigo, nombre, descripcion)
	InventarioS= array[0..max_fila, 0..3] of String;

	// Almacena solo los datos numericos de un inventario (cantidad, precio)
	InventarioI= array[0..max_fila, 0..2] of Integer;

	// Almacena solo las cadenas de caracteres de una factura  (CodigoProd, nombreC, apellidoC, cedulaC, direccionC)
	FacturaS= array[0..max_fila, 0..5] of String;

	// Almacena solo las fechas de emision una factura (dia, mes, año)
	FacturaF= array[0..max_fila, 0..3] of Integer;

	// Almacena solo los montos de los productos en una factura (codigo, cantProd, montoProd)
	montosFactura= array[0..max_fila, 0..3] of Integer;


{
	Declaracion de Variables
}

var

	salida: Boolean;
	opcion: Integer;
	guardar: Boolean;
	prod: Producto;
	client: Cliente;
	fact: Factura;
	invS: InventarioS;
	invI: InventarioI;
	factS: FacturaS;
	factF:FacturaF;
	mfact: montosFactura;
	i: Integer;
	j: Integer;	

{
	Declaracion de funciones
}

	(* Consulta la disponibilidad de un producto en el inventario *)

function disponibilidad(codigo: String): Integer;
var
	total: Integer;
	id: Integer;

begin
	
	for i := 0 to max_fila do
		begin
			
			for j := 0 to 3 do
			begin
				
				if invS[i][j] = prod.codigo then
				begin
					
					id:= i;

				end;

			end;

		end;


	total:= invI[id][0];

end;


	(* Consulta el monto total de productos del inventario *)

function totalInventario(): Integer;
var
	total: Integer;
	contador: Integer;

begin

	contador:= 0;
	
	for i := 0 to 2 do
		begin
			
			contador:= contador + (invI[i][0] * invI[i][1]);

		end;


	total:= contador;

end;

	(* Agrega un producto al inventario *)

function agregarProducto(codigo, nombre, descripcion: String; cantidad, precio: Integer): Boolean;
var
	producto: Boolean;

begin

	guardar:= false;
	
	// Guardamos el producto en el inventario

	for i := 0 to max_fila do
	begin

		// Verificamos que la fila este vacia
		if (invS[i][0] = '') and (guardar=false) then
		begin

			// Guardamos el producto

			// Cadena de caracteres
			invS[i][0]:= codigo;
			invS[i][1]:= nombre;
			invS[i][2]:= descripcion;

			// Datos numericos
			invI[i][0]:= cantidad;
			invI[i][1]:= precio;

			guardar:= true;

		end;

	end;

	producto:= guardar;	

end;

	(* Elimina un producto del inventario *)

function eliminarProducto(codigo: String): Boolean;
var
	eliminado: Boolean;
	producto: Boolean;

begin

	producto:= false;
	
	for i := 0 to max_fila do
	begin
		
		for j := 0 to 3 do
		begin
			
			if invS[i][0] = codigo then
			begin
				
				// Eliminamos de la 1era matriz de String
				invS[i][0]:= '';
				invS[i][1]:= '';
				invS[i][2]:= '';

				invI[i][0]:= 0;
				invI[i][1]:= 0;

				producto:= true;

			end;

		end;

	end;

	eliminado:= producto;

end;


	(* Validamos el total de existencia de un producto en el inventario *)

function validarExistencia(codigo: String): Integer;
var
	total: Integer;
	producto: Integer;
begin
	
	producto:= 0;
	
	for i := 0 to max_fila do
	begin
		
			
		if invS[i][0] = codigo then
		begin
			
			producto:= invI[i][0];

		end;

	end;

	total:= producto;

end;


	(* Agrega los datos de un cliente y la fecha a una factura *)

function agregarDatosFactura(nombre, apellido, cedula, direccion: String; dia, mes, anno: Integer): Integer;
var
	factura: Integer;
	guardar: Integer;
begin
	
	factura:= 0;
	guardar:= -1;

	// Guardamos los datos producto a la factura

	for i := 0 to max_fila do
	begin

		// Verificamos si hay disponibilidad para guardar (Si está vacia esa fila de la matriz)
		if (factS[i][0] = '') and (guardar = -1) then
		begin
			// Guardamos 

			// Descripciones del producto
			factS[i][0]:= invS[i][0];

			// Descripciones del cliente
			factS[i][1]:= nombre;
			factS[i][2]:= apellido;
			factS[i][3]:= cedula;
			factS[i][4]:= direccion;

			// Fecha
			factF[i][0]:= dia;
			factF[i][1]:= mes;
			factF[i][2]:= anno;

			if i=0 then 
				begin
					guardar:= 0;
				end
			else 
				begin
					guardar:= i;
				end;

		end;

	end;

	factura:= guardar;

end;


	(* Agrega los datos de un producto a una factura *)

function agregarproductoFactura(codigoProd: String; codigoFact, cantidadProd: Integer): Boolean;
var
	factura: Boolean;
	accion: Boolean;

begin

	accion:= false;
	
	// Guardamos los datos producto a la factura

	for i := 0 to max_fila do
	begin

		// Buscamos el producto

		if (invS[i][0] = codigoProd) then
		begin

			for j := 0 to max_fila do
			begin
				
				// Verificamos la disponibilidad de espacio la matriz de monto de factura

				if (mfact[j][1]=0) and (accion=false) then
				begin
					// Validamos de guardar en distintos registros la primera factura del sistema
						
					// Monto
					mfact[j][0]:= codigoFact;
					mfact[j][1]:= cantidadProd;
					mfact[j][2]:= invI[j][1];

					accion:= true;
					
				end;

			end;

		end;

	end;

	factura:= accion;

end;

function precioProducto(codigoProd: String): Integer;
var 
	precio: Integer;
begin

	precio:= 0;

	for i := 0 to max_fila do
	begin

		// Buscamos el producto

		if (invS[i][0] = codigoProd) then
		begin

			// Guardamos el precio
			precio:= invI[i][1];
			
		end;

	end;

	precio:= precio;
	
end;

	(* Actualizamos el inventario de acuerdo a los productos adquiridos en una factura procesada *)

function actualizarInventario(codFact: Integer): Boolean;
var
	inventario: Boolean;
	guardar: Boolean;
begin
	
	guardar:= false;

	for i := 0 to max_fila do
	begin

		// Buscamos el producto en el inventario
		if (mfact[i][0] = codFact) and (guardar=false) then
		begin

			// Restamos la cantida de productos que adquirió el usuario al inventario

			// Actualizamos inventario
			invI[i][0]:= invI[i][0] - mfact[i][1];

			guardar:= true;

		end;

	end;

	inventario:= guardar;

end;


	(* Eliminamos las facturas procesadas en el sistema *)

function eliminarFactura(codFact: Integer): Boolean;
var
	factura: Boolean;
	eliminar: Boolean;
begin
	
	eliminar:= false;

	for i := 0 to max_fila do
	begin

		// Buscamos el producto en el inventario
		if mfact[i][0] = codFact then
		begin

			// Restamos la cantida de productos que adquirió el usuario al inventario

			// Eliminamos los datos del cliente asociado a la factura
			factS[i][0]:= '';
			factS[i][1]:= '';
			factS[i][2]:= '';
			factS[i][3]:= '';
			factS[i][4]:= '';
			factS[i][5]:= '';

			// Eliminamos las fechas (dia, mes, año)

			factF[i][0]:= 0;
			factF[i][1]:= 0;
			factF[i][2]:= 0;

			// Eliminamos los montos de los productos de una factura

			mfact[i][0]:= 0;
			mfact[i][1]:= 0;
			mfact[i][2]:= 0;

			eliminar:= true;

		end;

	end;

	factura:= eliminar;

end;


	(* Consultamos las ventas diarias de acuerdo a una fecha consultada*)

function ventasDiarias(dia, mes, anno: Integer): Integer;
var
	ventas: Integer;
	contador: Integer;
begin
	
	ventas:= 0;
	contador:= 0;

	for i := 0 to max_fila do
	begin

		// Buscamos facturas que correspondan a esa fecha del día
		if (factF[i][0] = dia) and (factF[i][1] = mes) and (factF[i][2] = anno) and (factF[i][0]<>0) then
		begin

			// Contamos como venta del dia

			contador:= contador+1;

		end;

	end;

	ventas:= contador;

end;


	(* Consultamos las ventas mensuales de acuerdo a un mes consultado*)

function ventasMensuales(mes, anno: Integer): Integer;
var
	ventas: Integer;
	contador: Integer;

begin
	
	ventas:= 0;
	contador:= 0;

	for i := 0 to max_fila do
	begin

		// Buscamos facturas que correspondan a esa fecha del día
		if (factF[i][1] = mes) and (factF[i][2] = anno) and (factF[i][0]<>0) then
		begin

			// Contamos como venta del dia

			contador:= contador+1;

		end;

	end;

	ventas:= contador;

end;

	(* Menu de Inventario *)

function menuInventario(): Integer;
var 
	opcionFinal, atras, salir: Integer;

begin

	opcionFinal:= 0; 
	atras:= 0; 
	salir:= 0;

	repeat

		// Limpiamos pantalla
		clrscr;

		// Inicializamos el control de salida y opciones
		opcion:= 0;

		writeln(' * Modulo Inventario: ');
		writeln(' 1. Añadir producto');
		writeln(' 2. Consultar disponibilidad de producto');
		writeln(' 3. Consultar monto de inventario');
		writeln(' 4. Eliminar producto');
		writeln(' 0. Atras');
		writeln(' 9. Salir');
		writeln(' ');
		write(' Opción: ');
		
		read(opcion);

		case opcion of

			1: begin
						// Limpiamos pantalla
						clrscr;

						// Esperamos tecla	
						readln();

						writeln('* Detalles del producto:');
						writeln('  ');

						writeln(' Ingrese  el codigo del producto: ');
						readln(prod.codigo);
						
						writeln(' Ingrese el nombre: ');
						readln(prod.nombre);
						
						writeln(' Ingrese una descripcion: ');
						readln(prod.descripcion);
						
						writeln(' Ingrese la cantidad de productos: ');
						readln(prod.cantidad);
						
						writeln(' Ingrese el precio unitario: ');
						readln(prod.precio);					

						// Guardamos el producto

						if agregarProducto(prod.codigo, prod.nombre, prod.descripcion, prod.cantidad, prod.precio) = true then
							begin
								writeln('');
								writeln('¡Producto agregado exitosamente! ');
								readln();
							end
						else
							begin
								writeln('');
								writeln('¡Error! El Producto no se pudo agregar.. ');
								readln();
							end;

					end;


			2: begin
						// Limpiamos pantalla
						clrscr;

						// Esperamos tecla
						readln();

						writeln('* Disponibilidad de producto: ');
						writeln(' ');
						
						writeln('Ingrese el codigo del producto: ');
						read(prod.codigo);

						readln();
						writeln(' ');
						writeln('Total de productos en existencia: ', disponibilidad(prod.codigo)); 

						readln();

					end;

			3: begin
						// Limpiamos pantalla
						clrscr;

						// Esperamos tecla
						readln();

						writeln('El monto total de productos en el inventario es de: ', totalInventario(),'Bs');

						// Esperamos tecla
						readln();

					end;

			4: begin

						readln();

						writeln('* Eliminar un producto del inventario.');
						writeln(' ');
						writeln('Ingrese el codigo del producto a eliminar: ');
						readln(prod.codigo);

						if eliminarProducto(prod.codigo) = true then 
							begin
								writeln(' ');
								writeln('¡El producto se eliminó exitosamente!');
							end
						else 
							begin
								writeln(' ');
								writeln('Código del producto no encontrado.! No se puede eliminar..');
							end;

						readln();
					end;

			0: begin
						atras:= 1;
					end;

			9: begin
						salir:= 2;
					end;

			else
		        begin
		           writeln(' Opción invalida! ');
		           readln();
		        end;
		end;
		
	until (atras=1) or (salir=2);

	opcionFinal:= atras+salir;
	
end;

	(* Visualizar todas y una factura en especifico *)

function visualizarFacturas(mes, anno: Integer): Boolean;
var
	factura: Boolean;
	buscar: Integer;
	total: Integer;

begin

	
	buscar:= 0;
	total:= 0;

	// Limpiamos pantalla
	clrscr;

	writeln('');
	writeln('* Facturas del mes: ');
	writeln('');
	
	for i := 0 to max_fila do
	begin
		
		if (factF[i][1] = mes) and (factF[i][2] = anno) then
		begin
			
			writeln( i+1,'. Codigo Factura: ', mfact[i][0]);
			writeln( 'Fecha: ', factF[i][0], '-',factF[i][1],'-',factF[i][2]);

		end;

	end;	

	writeln('  ');
	writeln('Codigo de la factura a visualizar con detalles: ' );
	readln(buscar);

	factura:= false;

	for i := 0 to max_fila do
		begin
			
			if mfact[i][0] = buscar then
			begin

				if factura = false then
				begin

					// Limpiamos pantalla
					clrscr;

					writeln('-----------***** Factura *****----------');
					writeln('* Datos del cliente: ');
					writeln(' ');
					writeln('. Nombre: ', factS[i][1]);
					writeln('. Apellido: ', factS[i][2]);
					writeln('. Cedula: ', factS[i][3]);
					writeln('. Direccion: ', factS[i][4]);

					writeln(' ');
					writeln(' ');

					writeln('* Datos de la Factura: ');
					writeln(' ');
					writeln('Codigo Factura: ', mfact[i][0]);
					writeln('Fecha: ', factF[i][0], '-',factF[i][1],'-',factF[i][2]);
					writeln('  ');

					factura:= true;
				end;

				if factS[i][1]<>'' then
				begin
					writeln('  ');
					writeln('Codigo Producto: ', factS[i][0]);
					writeln('Cantidad: ', mfact[i][1], '  Precio: ', mfact[i][2], 'Bs');
					total:= total+(mfact[i][1]*mfact[i][2]);
				end;

			end;

		end;

	writeln('  ');
	writeln('Total: ', total, 'Bs');

	readln();
	readln();

	Factura:= true;


end;

	(* Modificar una factura *)

function modificarFactura(codFact: Integer): Boolean;
var
	factura, accion: Boolean;
	modificar: String;
	total: Integer;

begin

	factura:= false;
	total:= 0;

	for i := 0 to max_fila do
	begin
		
		if mfact[i][0] = codFact then
		begin

			if factura = false then
			begin

				// Limpiamos pantalla
				clrscr;

				writeln('-----------***** Factura *****----------');
				writeln('* Datos del cliente: ');
				writeln(' ');
				writeln('. Nombre: ', factS[i][1]);
				writeln('. Apellido: ', factS[i][2]);
				writeln('. Cedula: ', factS[i][3]);
				writeln('. Direccion: ', factS[i][4]);

				writeln(' ');
				writeln(' ');

				writeln('* Datos de la Factura: ');
				writeln(' ');
				writeln('Codigo Factura: ', mfact[i][0]);
				writeln('Fecha: ', factF[i][0], '-',factF[i][1],'-',factF[i][2]);
				writeln('  ');

				factura:= true;
			end;

			if mfact[i][1]<>0 then
			begin
				writeln('  ');
				writeln('Codigo Producto: ', factS[i][0]);
				writeln('Cantidad: ', mfact[i][1], '  Precio: ', mfact[i][2], 'Bs');
				total:= total+(mfact[i][1]*mfact[i][2]);
			end;

		end;

	end;

	writeln('  ');
	writeln('Total: ', total, 'Bs');
	writeln('  ');


	writeln('*--- Modificacion ---*');
	writeln('Codigo del producto a modificar: ');
	readln(modificar);

	writeln('Cantidad: ');
	readln(prod.cantidad);

	accion:= false;

	// Guardamos las modificaciones de datos del producto a la factura

	for i := 0 to max_fila do
	begin

		// Buscamos el producto

		if (invS[i][0] = modificar) and (accion=false) then
		begin

			// Validamos que la cantidad del producto nueva sea mayor a la anterior 

			if prod.cantidad>mfact[i][1] then 
				begin

					// Actualizamos el inventario
					invI[i][0]:= invI[i][0]-(prod.cantidad-mfact[i][1]);

					// Monto
					mfact[i][1]:= prod.cantidad;
					mfact[i][2]:= invI[i][1];

					accion:= true;
					
				end
			else 
				begin
					writeln('No se puede modificar el producto! ');
					readln();
				end;
			
		end;

	end;	

	Factura:= accion;


end;


	(* Menu de Inventario *)

function menuVentas(): Integer;
var 
	opcionFinal, atras, salir, totalProd, totalFact: Integer;
	cantProd: Boolean;

begin

	cantProd:= false;
	opcionFinal:= 0; 
	atras:= 0; 
	salir:= 0;

	repeat

		// Limpiamos pantalla
		clrscr;

		// Inicializamos el control de salida y opciones
		opcion:= 0;

		writeln(' * Modulo Ventas: ');
		writeln(' ');

		writeln(' 1. Crear factura');
		writeln(' 2. Modificar factura');
		writeln(' 3. Eliminar factura');
		writeln(' ');

		writeln(' Consultas: ');
		writeln(' 4. Facturas');
		writeln(' 5. Ventas diarias');
		writeln(' 6. Ventas mensuales');
		writeln(' ');

		writeln(' 0. Atras');
		writeln(' 9. Salir');
		writeln(' ');
		write(' Opción: ');

		read(opcion);

		case opcion of

			1: begin
						// Inicializamos el contador de productos
						totalProd:= 0;

						// Inicializamos el total de la factura
						totalFact:= 0;
						// Limpiamos pantalla
						clrscr;

						// Esperamos tecla	
						readln();

						writeln('----------*** Factura ***----------');
						
						writeln('  ');
						writeln('* Fecha de la factura:');
						writeln('  ');

						writeln('Dia: ');
						readln(fact.dia);

						writeln('Mes: ');
						readln(fact.mes);

						writeln('Año: ');
						readln(fact.anno);


						writeln('  ');
						writeln('* Datos Cliente:');
						writeln('  ');

						writeln('Nombre: ');
						readln(client.nombre);

						writeln('Apellido: ');
						readln(client.apellido);

						writeln('Cédula: ');
						readln(client.cedula);

						writeln('Dirección de residencia: ');
						readln(client.direccion);
						writeln('  ');

						// Agregamos los datos del cliente a la factura y guardamos el codigo de factura
						fact.codigo:= agregarDatosFactura(client.nombre, client.apellido, client.cedula, client.direccion, fact.dia, fact.mes, fact.anno);

													
						repeat

							// Limpiamos pantalla
							clrscr;

							writeln('----------*** Factura ***----------');
							writeln('  ');
							writeln('Codigo de la factura: ', fact.codigo);
							writeln('Nombre y Apellido: ', client.nombre, ' ', client.apellido);
							writeln('Cedula: ', client.cedula);
							writeln('Direccion: ', client.direccion);
							writeln('  ');
							writeln('Cantidad de productos añadidos en la factura: ', totalProd);
							
							
							writeln('  ');
							writeln('  ');

							cantProd:= false;

							writeln('* Producto:');
							writeln('  ');

							writeln('Código: ');
							readln(prod.codigo);

							writeln('Cantidad: ');
							readln(prod.cantidad);

							// Verificamos que la cantidad de productos se encuentren disponibles en el inventario

							if prod.cantidad<=validarExistencia(prod.codigo) then 
								begin

									// Agregamos los datos del producto a la factura
									
									if agregarproductoFactura(prod.codigo, fact.codigo, prod.cantidad) = true then
									begin
										
										totalProd:= totalProd + 1;
										totalFact:= totalFact+(prod.cantidad*precioProducto(prod.codigo));
										writeln('¡Producto agregado exitosamente!');

										if actualizarInventario(fact.codigo) = true then
										begin
											writeln('  ');
											writeln('Total a cancelar: ', totalFact,'Bs');
											writeln('El stock del inventario ha sido actualizado. ');
											readln();
										end;

									end;
									
								end
							else 
								begin
									writeln('  ');
									writeln('No se pudo agregar esa cantidad productos a la factura! ');
									writeln('Solo existen en inventario: ', validarExistencia(prod.codigo));
									readln();
								end;

							writeln('Desea agregar otro producto a la factura (1. Si - 2. No): ');
							readln(opcion);

							if opcion = 2 then
							begin

								// No se agregan mas productos a la factura..
								cantProd:= true;
							end;
							
						until cantProd=true;

					end;

			2: begin
						// Limpiamos pantalla
						clrscr;

						writeln('  ');
						writeln('Ingrese el codigo de la factura a modificar:');
						readln(fact.codigo);

						if modificarFactura(fact.codigo)= true then
							begin
							
								writeln('  ');
								writeln('¡La factura se modifico exitosamente!');

							end
						else
							begin
							
								writeln('  ');
								writeln('Error al modificar la factura..!');

							end;

						readln();

					end;

			3: begin
						// Limpiamos pantalla
						clrscr;

						writeln(' * Eliminar Factura');
						writeln(' ');
						writeln(' Ingrese el codigo de la factura a eliminar: ');
						read(fact.codigo);
						
						if eliminarFactura(fact.codigo) = true then
							begin
								writeln(' ');
								writeln(' Factura Eliminada con Exito! ');
								readln();
							end
						else
							begin
								writeln(' ');
								writeln(' Codigo de factura no existe en los registros! No se pudo eliminar.. ');
								readln();
							end;

						readln();

					end;

			4: begin
						// Limpiamos pantalla
						clrscr;

						writeln('  ');
						writeln('* Ingrese la Fecha de las facturas a consultar:');
						writeln('  ');

						writeln('Mes: ');
						readln(fact.mes);

						writeln('Año: ');
						readln(fact.anno);

						if visualizarFacturas(fact.mes, fact.anno)=true then
						begin
							
							read();

						end;

					end;

			5: begin
						// Limpiamos pantalla
						clrscr;

						writeln('  ');
						writeln('* Ingrese la Fecha de las Ventas a consultar:');
						writeln('  ');

						writeln('Dia: ');
						readln(fact.dia);

						writeln('Mes: ');
						readln(fact.mes);

						writeln('Año: ');
						readln(fact.anno);

						writeln(' ');
						writeln('El total de ventas de ese día es de: ', ventasDiarias(fact.dia, fact.mes, fact.anno));
						readln();

						
					end;

			6: begin
						// Limpiamos pantalla
						clrscr;

						writeln('  ');
						writeln('* Ingrese la Fecha de las Ventas a consultar:');
						writeln('  ');

						writeln('Mes: ');
						readln(fact.mes);

						writeln('Año: ');
						readln(fact.anno);

						writeln(' ');
						writeln('El total de ventas del mes: ', ventasMensuales(fact.mes, fact.anno));
						readln();

					end;

			0: begin
						atras:= 1;
					end;

			9: begin
						salir:= 2;
					end;
			else
		        begin
		           writeln(' Opción invalida! ');
		        end;
		end;
		
	until (atras=1) or (salir=2);

	opcionFinal:= atras+salir;
	
end;


{
	Declaracion de Procedimientos
}

	(* Menu principal*)

procedure menuPrincipal();
begin
	
	repeat

		// Limpiamos pantalla
		clrscr;

		// Inicializamos el control de salida y opciones
		salida:= false;
		opcion:= 0;

		writeln('¡Bienvenido al Sistema de Control de Ventas-Inventario de Kioto!');
		writeln('  ');
		writeln('  ');
		writeln(' Modulos: ');
		writeln('  ');
		writeln(' 1. Inventario');
		writeln(' 2. Ventas ');
		writeln(' 0. Salir ');
		writeln('  ');
		write(' Opción: ');
		read(opcion);

		case opcion of

			1: begin
						// Ejecutamos el menu de inventario

						if menuInventario()= 9 then
						begin
							salida:= true;
						end;

					end;

			2: begin
					    // Ejecutamos el menu de ventas
						
						if menuVentas()= 9 then
						begin
							salida:= true;
						end;

					end;

			0: begin
						//writeln(' Haz seleccionado la opcion salir');
						salida:= true;
					end;
			else

		        begin
		           writeln(' Opción invalida! ');
		        end;

		end;
		
	until salida=true;

end;


	(* Inicializar Matrices *)

procedure inicializarMatrices();
begin
	
	for i := 0 to max_fila do
	begin
		
		for j := 0 to 5 do
		begin

			// Inicializamos la matriz de cadenas de caracteres de una factura como vacias
			factS[i][j]:= '';
		
			if j<3 then
			begin

				// Inicializamos la matriz de cadenas de caracteres de un inventario como vacias
				invS[i][j]:= '';

				// Inicializamos la matriz de datos de montos de facturas en 0
				mfact[i][j]:= 0;

				// Inicializamos la matriz de fechas de facturas en 0
				factF[i][j]:= 0;
			end;

			if (i<2) and (j<2) then
			begin
			
				// Inicializamos la matriz de datos del inventario numericos en 0
				invI[i][j]:= 0;

			end;
			
		end;

	end;


end;

	(* Funcion Principal *)

begin
	
	// Inicializamos las matrices
	inicializarMatrices();

	// Ejecutamos el menu principal
	menuPrincipal();
	
end.
