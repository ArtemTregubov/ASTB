#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция УстановитьFTPСоединение(ПараметрыЗагрузки) Экспорт
	
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	
	Если НастройкаПроксиСервера <> Неопределено Тогда
		
		ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		ИспользоватьСистемныеНастройки = НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки");
		
		Если ИспользоватьПрокси Тогда
			
			Если ИспользоватьСистемныеНастройки Тогда
			// Системные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси(Истина);
			Иначе
			// Ручные настройки прокси-сервера
				Прокси = Новый ИнтернетПрокси;
				Прокси.Установить("ftp", НастройкаПроксиСервера["Сервер"], НастройкаПроксиСервера["Порт"]);
				Прокси.Пользователь 							= НастройкаПроксиСервера["Пользователь"];
				Прокси.Пароль       							= НастройкаПроксиСервера["Пароль"];
				Прокси.НеИспользоватьПроксиДляЛокальныхАдресов 	= НастройкаПроксиСервера["НеИспользоватьПроксиДляЛокальныхАдресов"];
			КонецЕсли;
			
		Иначе
			
			// Не использовать прокси-сервер	
			Прокси = Новый ИнтернетПрокси(Ложь);
			
		КонецЕсли;
		
	Иначе
		
		Прокси = Неопределено;
		
	КонецЕсли;

	Попытка
		FTPСоединение = Новый FTPСоединение(ПараметрыЗагрузки.FTPСоединениеАдрес,
										ПараметрыЗагрузки.FTPСоединениеПорт,
										ПараметрыЗагрузки.FTPСоединениеПользователь,
										ПараметрыЗагрузки.FTPСоединениеПароль,
										Прокси,
										ПараметрыЗагрузки.FTPСоединениеПассивноеСоединение);
										
		//Трегубов А.А. -- №142456  --  10.11.2021 <<<
		Если ЗначениеЗаполнено(СокрЛП(ПараметрыЗагрузки.FTPСоединениеПуть)) Тогда 
			FTPСоединение.УстановитьТекущийКаталог(СокрЛП(ПараметрыЗагрузки.FTPСоединениеПуть));
		КонецЕсли;
		//Трегубов А.А. -- №142456  --  10.11.2021 >>>
		
	Исключение
		FTPСоединение = Неопределено;
	КонецПопытки;
	
	Возврат FTPСоединение;

КонецФункции

Функция ПроверитьИзображенияНаFTP(Объект) Экспорт
	
	ПараметрыЗагрузки = Новый Структура(
		"FTPСоединениеАдрес, FTPСоединениеПароль, FTPСоединениеПассивноеСоединение, FTPСоединениеПользователь, FTPСоединениеПорт, FTPСоединениеПуть",
		Объект.FTPСоединениеАдрес, Объект.FTPСоединениеПароль, Объект.FTPСоединениеПассивноеСоединение, Объект.FTPСоединениеПользователь, Объект.FTPСоединениеПорт, Объект.FTPСоединениеПуть);
	//ЗаполнитьЗначенияСвойств(ПараметрыЗагрузки, ЭтаФорма);
	
	Соединение = УстановитьFTPСоединение(ПараметрыЗагрузки);
	Если Соединение = Неопределено Тогда
		Сообщить("Ошибка подключения к FTP-ресурсу.");
		Возврат Неопределено;
	КонецЕсли;
	
	МассивФайлов = Соединение.НайтиФайлы(,"*",Ложь);
	
	Если МассивФайлов.Количество() = 0 Тогда
		Сообщить("Не найдены файлы по указанному пути.");
		Возврат Неопределено;
	Иначе
		Если НЕ (МассивФайлов[0].Расширение = ".jpg") Тогда //ошибка получения массива файлов (иногда случается даже при удачном подключении к FTP)
			Сообщить("Ошибка получения файлов изображений. Возможно, неверно настроены параметры прокси-сервера.");
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МассивФайлов;
	
КонецФункции

Процедура ЗаполнитьТаблицуДляЗагрузки(Объект,РежимЗагрузкиИзСайта = Истина) Экспорт	
	
	//Трегубов А.А. -- №142456 Параметр "РежимЗагрузкиСайта" = Истина добавлен для сохранения функционала загрузки изображений с ФТП до лучших времен --  10.11.2021 <<<		
	Если РежимЗагрузкиИзСайта Тогда 
		ЗаполнитьТаблицуДляЗагрузкиИзСайта(Объект);
	Иначе
		ЗаполнитьТаблицуДляЗагрузкиСФТП(Объект);
	КонецЕсли;	
	//Трегубов А.А. -- №142456 Параметр "РежимЗагрузкиСайта" = Истина добавлен для сохранения функционала загрузки изображений с ФТП до лучших времен --  10.11.2021 >>>	

КонецПроцедуры

Процедура ВыполнитьЗагрузку(Объект,УникальныйИдентификаторФормы,РежимЗагрузкиИзСайта = Истина) Экспорт
	
	//Трегубов А.А. -- № 142456 Параметр "РежимЗагрузкиСайта" = Истина добавлен для сохранения функционала загрузки изображений с ФТП до лучших времен --  10.11.2021 <<<	
	Если РежимЗагрузкиИзСайта Тогда 
		ВыполнитьЗагрузкуИзСайта(Объект,УникальныйИдентификаторФормы);
	Иначе
		ВыполнитьЗагрузкуСФТП(Объект,УникальныйИдентификаторФормы);
	КонецЕсли;		
	//Трегубов А.А. -- №142456 Параметр "РежимЗагрузкиСайта" = Истина добавлен для сохранения функционала загрузки изображений с ФТП до лучших времен --  10.11.2021 >>>	
	
КонецПроцедуры

#область ЗагрузкаИзображенийСФТП

//Трегубов А.А. -- № 142456 Не стал избавляться от загрузки с ФТП, возможно когда-нибудь вернемся --  10.11.2021 
Процедура ВыполнитьЗагрузкуСФТП(Объект,УникальныйИдентификаторФормы)
	
	//проверка состояния таблицы номенклатуры
	Если Объект.ТаблицаДляЗагрузки.Количество() = 0 Тогда
		Сообщить("Перед загрузкой изображений необходимо заполнить таблицу.");
		Возврат;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаНоменклатуры.Использовать
		|ПОМЕСТИТЬ ТаблицаНоменклатуры
		|ИЗ
		|	&ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
		|ГДЕ
		|	ТаблицаНоменклатуры.Использовать = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаНоменклатуры.Использовать
		|ИЗ
		|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры";
		
		Запрос.УстановитьПараметр("ТаблицаНоменклатуры",Объект.ТаблицаДляЗагрузки.Выгрузить());
		Выборка = Запрос.Выполнить().Выбрать();
		Если НЕ Выборка.Следующий() Тогда
			Сообщить("Выберите хотя бы одну строку в таблице для обновления изображения.");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗагрузки = Новый Структура(
		"FTPСоединениеАдрес, FTPСоединениеПароль, FTPСоединениеПассивноеСоединение, FTPСоединениеПользователь, FTPСоединениеПорт, FTPСоединениеПуть",
		Объект.FTPСоединениеАдрес, Объект.FTPСоединениеПароль, Объект.FTPСоединениеПассивноеСоединение, Объект.FTPСоединениеПользователь, Объект.FTPСоединениеПорт, Объект.FTPСоединениеПуть);
	//ЗаполнитьЗначенияСвойств(ПараметрыЗагрузки, ЭтаФорма);
	
	Соединение = УстановитьFTPСоединение(ПараметрыЗагрузки);
	Если Соединение = Неопределено Тогда
		Сообщить("Ошибка подключения к FTP-ресурсу.");
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицыДляЗагрузки Из Объект.ТаблицаДляЗагрузки Цикл
		
		Если НЕ СтрокаТаблицыДляЗагрузки.Использовать Тогда
			Продолжить;
		КонецЕсли;
		
		Если (Не ЗначениеЗаполнено(СтрокаТаблицыДляЗагрузки.Изображение)) ИЛИ (Не ЗначениеЗаполнено(СтрокаТаблицыДляЗагрузки.ДатаЗагрузки)) Тогда
			//Трегубов А.А. -- № 142456   --  10.11.2021 <<<
			ЗагрузитьИзображениеНоменклатурыСФТП(СтрокаТаблицыДляЗагрузки,Соединение,УникальныйИдентификаторФормы);
			//ЗагрузитьИзображениеНоменклатуры(СтрокаТаблицыДляЗагрузки,Соединение,УникальныйИдентификаторФормы);			
			//Трегубов А.А. -- № 142456  --  10.11.2021 >>>
		Иначе
			Если СтрокаТаблицыДляЗагрузки.ДатаЗагрузки < СтрокаТаблицыДляЗагрузки.ДатаНаFTP Тогда
				//Трегубов А.А. -- № 142456  --  10.11.2021 <<<
				ЗагрузитьИзображениеНоменклатурыСФТП(СтрокаТаблицыДляЗагрузки,Соединение,УникальныйИдентификаторФормы);
				//ЗагрузитьИзображениеНоменклатуры(СтрокаТаблицыДляЗагрузки,Соединение,УникальныйИдентификаторФормы);
				//Трегубов А.А. -- № 142456  --  10.11.2021 >>>
			Иначе
				Сообщить("Для номенклатуры: " + СокрЛП(СтрокаТаблицыДляЗагрузки.Номенклатура.Наименование) + " обновление изображения не требуется.");
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьТаблицуДляЗагрузки(Объект);

КонецПроцедуры

//Трегубов А.А. -- № 142456 Не стал избавляться от загрузки с ФТП, возможно когда-нибудь вернемся --  10.11.2021 
Процедура ЗаполнитьТаблицуДляЗагрузкиСФТП(Объект)
	
	МассивФайлов = ПроверитьИзображенияНаFTP(Объект);
	
	Объект.ТаблицаДляЗагрузки.Очистить();
	
	Если МассивФайлов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КС 				= Новый КвалификаторыСтроки(25);
	Массив 			= Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС 	= Новый ОписаниеТипов(Массив, , КС);
	
	ТаблицаФайлов = Новый ТаблицаЗначений;
	ТаблицаФайлов.Колонки.Добавить("Артикул", ОписаниеТиповС);
	ТаблицаФайлов.Колонки.Добавить("Изменен", Новый ОписаниеТипов("Дата"));
	
	Для Каждого ЭлементМассиваФайлов Из МассивФайлов Цикл
		
		Если НЕ Найти(ЭлементМассиваФайлов.ИмяБезРасширения,"_") = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока 		= ТаблицаФайлов.Добавить();
		НоваяСтрока.Артикул = СокрЛП(ЭлементМассиваФайлов.ИмяБезРасширения);
		НоваяСтрока.Изменен = ЭлементМассиваФайлов.ПолучитьВремяИзменения();
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФайлыНаФТП.Артикул КАК Артикул,
	|	ФайлыНаФТП.Изменен
	|ПОМЕСТИТЬ ФайлыНаФТП
	|ИЗ
	|	&ФайлыНаФТП КАК ФайлыНаФТП
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Артикул
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛОЖЬ КАК Использование,
	|	ФайлыНаФТП.Изменен КАК ДатаНаFTP,
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	ЕСТЬNULL(Номенклатура.Артикул, ФайлыНаФТП.Артикул) КАК Артикул,
	|	Номенклатура.ФайлКартинки КАК Изображение,
	|	Номенклатура.ФайлКартинки.ДатаСоздания КАК ДатаЗагрузки
	|ИЗ
	|	(ВЫБРАТЬ
	|		Номенклатура.Ссылка КАК Ссылка,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.ФайлКартинки КАК ФайлКартинки
	|	ИЗ
	|		Справочник.Номенклатура КАК Номенклатура
	|	ГДЕ
	|		Номенклатура.ЭтоГруппа = ЛОЖЬ
	|		И НЕ Номенклатура.Артикул = """") КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ФайлыНаФТП КАК ФайлыНаФТП
	|		ПО Номенклатура.Артикул = ФайлыНаФТП.Артикул
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура.Ссылка.Наименование";
	
	Запрос.УстановитьПараметр("ФайлыНаФТП",ТаблицаФайлов);
	
	Объект.ТаблицаДляЗагрузки.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

//Трегубов А.А. -- № 142456 Не стал избавляться от загрузки с ФТП, возможно когда-нибудь вернемся --  10.11.2021 
Процедура ЗагрузитьИзображениеНоменклатурыСФТП(СтрокаТаблицы,Соединение,УникальныйИдентификаторФормы)
	
	Попытка
		ВременныйКаталог 	= ?(Прав(КаталогВременныхФайлов(),1) = "\",КаталогВременныхФайлов(),КаталогВременныхФайлов() + "\");
		ПолноеИмяФайла 		= ВременныйКаталог + СокрЛП(СтрокаТаблицы.Артикул) + ".jpg";
		ИмяФайла 			= СокрЛП(СтрокаТаблицы.ДатаНаFTP) + "_" + СокрЛП(СтрокаТаблицы.Артикул) + ".jpg";	
		Соединение.Получить(СокрЛП(СтрокаТаблицы.Артикул) + ".jpg",ПолноеИмяФайла);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;

	ВладелецФайла = СтрокаТаблицы.Номенклатура;
	
	ОбщиеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами();
	
	Файл = Новый Файл(ПолноеИмяФайла);
	
	Если ОбщиеНастройки.ИзвлекатьТекстыФайловНаСервере Тогда
		АдресВременногоХранилищаТекста = "";
	Иначе
		АдресВременногоХранилищаТекста = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекстВоВременноеХранилище(ПолноеИмяФайла, );
	КонецЕсли;
	
	ВремяИзмененияУниверсальное = Файл.ПолучитьУниверсальноеВремяИзменения();
	
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяФайла), УникальныйИдентификаторФормы);
	
	ПрисоединенныйФайл = ПрисоединенныеФайлыСлужебныйВызовСервера.ДобавитьФайл(ВладелецФайла,Файл.ИмяБезРасширения,
													ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(Файл.Расширение),,
													ВремяИзмененияУниверсальное,АдресВременногоХранилищаФайла,АдресВременногоХранилищаТекста);
	Попытка
		Номенклатура				= СтрокаТаблицы.Номенклатура.ПолучитьОбъект();
		Номенклатура.ФайлКартинки 	= ПрисоединенныйФайл;
		Номенклатура.Записать();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
													
КонецПроцедуры

#КонецОбласти

#область ЗагрузкаИзображенийИзСайта

//Трегубов А.А. -- № 142456 --  10.11.2021
Процедура ЗаполнитьТаблицуДляЗагрузкиИзСайта(Объект)
	
	ТаблицаФайлов = ТаблицаАдресовИзображенийИзСайта(Объект);
	
	Объект.ТаблицаДляЗагрузки.Очистить();
	
	Если ТаблицаФайлов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаФайлов.Артикул КАК Артикул,
	|	ТаблицаФайлов.ДатаНаFTP КАК ДатаНаFTP,
	|	ТаблицаФайлов.АдресИзображения КАК АдресИзображения
	|ПОМЕСТИТЬ ТаблицаФайлов
	|ИЗ
	|	&ТаблицаФайлов КАК ТаблицаФайлов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Артикул
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛОЖЬ КАК Использование,
	|	ТаблицаФайлов.ДатаНаFTP КАК ДатаНаFTP,
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	ЕСТЬNULL(Номенклатура.Артикул, ТаблицаФайлов.Артикул) КАК Артикул,
	|	Номенклатура.ФайлКартинки КАК Изображение,
	|	Номенклатура.ФайлКартинки.ДатаСоздания КАК ДатаЗагрузки,
	|	ТаблицаФайлов.АдресИзображения КАК АдресИзображения
	|ИЗ
	|	(ВЫБРАТЬ
	|		Номенклатура.Ссылка КАК Ссылка,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.ФайлКартинки КАК ФайлКартинки
	|	ИЗ
	|		Справочник.Номенклатура КАК Номенклатура
	|	ГДЕ
	|		Номенклатура.ЭтоГруппа = ЛОЖЬ
	|		И НЕ Номенклатура.Артикул = """") КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаФайлов КАК ТаблицаФайлов
	|		ПО Номенклатура.Артикул = ТаблицаФайлов.Артикул
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура.Ссылка.Наименование";
	
	Запрос.УстановитьПараметр("ТаблицаФайлов",ТаблицаФайлов);
	
	Объект.ТаблицаДляЗагрузки.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

//Трегубов А.А. -- №142456 из ЕИСФ  --  10.11.2021
Функция ТаблицаАдресовИзображенийИзСайта(Объект)
	
	ПараметрыЗагрузки = Новый Структура(
	"FTPСоединениеАдрес, FTPСоединениеПароль, FTPСоединениеПассивноеСоединение, FTPСоединениеПользователь, FTPСоединениеПорт, FTPСоединениеПуть",
	Объект.FTPСоединениеАдрес, Объект.FTPСоединениеПароль, Объект.FTPСоединениеПассивноеСоединение, Объект.FTPСоединениеПользователь, Объект.FTPСоединениеПорт, Объект.FTPСоединениеПуть);
	
	Соединение = УстановитьFTPСоединение(ПараметрыЗагрузки);
	Если Соединение = Неопределено Тогда
		Сообщить("Ошибка подключения к FTP-ресурсу.");
		Возврат Неопределено;
	КонецЕсли;
	
	ВременныйФайл = ПолучитьИмяВременногоФайла("csv");
	Соединение.Получить("products_shop.csv", ВременныйФайл);
	
	ЗагружаемыйФайл = Новый ТекстовыйДокумент;
	ЗагружаемыйФайл.Прочитать(ВременныйФайл);
	
	ТаблицаФайлов = Новый ТаблицаЗначений;
	ТаблицаФайлов.Колонки.Добавить("Артикул", ОбщегоНазначения.ОписаниеТипаСтрока(25));
	ТаблицаФайлов.Колонки.Добавить("АдресИзображения", ОбщегоНазначения.ОписаниеТипаСтрока(500));
	ТаблицаФайлов.Колонки.Добавить("ДатаНаFTP", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	
	СтруктураURI = СтруктураURI(Объект.HTTPСоединениеАдресСервераЧтения);
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост,СтруктураURI.Порт);
	
	НомерСтроки = 2;
	Пока СокрЛП(ЗагружаемыйФайл.ПолучитьСтроку(НомерСтроки)) <> "" Цикл
		
		Попытка
			
			ПолученнаяСтрока = СокрЛП(ЗагружаемыйФайл.ПолучитьСтроку(НомерСтроки));
			
			ДлСтроки = СтрДлина(ПолученнаяСтрока);
			Артикул = Лев(ПолученнаяСтрока, СтрНайти(ПолученнаяСтрока, ";")-1);
			ПолученнаяСтрока = Прав(ПолученнаяСтрока, ДлСтроки-СтрНайти(ПолученнаяСтрока, ";"));
			ДлСтроки = СтрДлина(ПолученнаяСтрока);
			Наименование = Лев(ПолученнаяСтрока, СтрНайти(ПолученнаяСтрока, ";")-1);
			ПолученнаяСтрока = Прав(ПолученнаяСтрока, ДлСтроки-СтрНайти(ПолученнаяСтрока, ";"));
			ДлСтроки = СтрДлина(ПолученнаяСтрока);
			Изображение = Лев(ПолученнаяСтрока, СтрНайти(ПолученнаяСтрока, ";")-1);
			Изображение = Прав(Изображение, СтрДлина(Изображение) - 16);
			ПолученнаяСтрока = Прав(ПолученнаяСтрока, ДлСтроки-СтрНайти(ПолученнаяСтрока, ";"));
			ДлСтроки = СтрДлина(ПолученнаяСтрока);
			ПутьКФайлу = Лев(ПолученнаяСтрока, СтрНайти(ПолученнаяСтрока, ";")-1);
			
			ПолноеНаименование = "";
			ИзображениеДлина = СтрДлина(Изображение)-1;
			н=0;
			Пока ИзображениеДлина > 0 Цикл
				Если Сред(Изображение, СтрДлина(Изображение)-н, 1) <> "/" Тогда
					ПолноеНаименование = Сред(Изображение, СтрДлина(Изображение)-н, 1) + ПолноеНаименование;
				Иначе
					Прервать;
				КонецЕсли;
				н = н + 1;
				ИзображениеДлина = ИзображениеДлина - 1;
			КонецЦикла;
			
			Если Не ЗначениеЗаполнено(ПолноеНаименование) Тогда
				Попытка
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неверный формат строки: "+ПолученнаяСтрока);
				Исключение			
				КонецПопытки;
				НомерСтроки = НомерСтроки + 1;
				Продолжить;
			КонецЕсли;
			
			HTTPЗапрос = Новый HTTPЗапрос(Изображение);
			Заголовок = HTTPСоединение.ПолучитьЗаголовки(HTTPЗапрос);
			ДатаИзменен = Заголовок.Заголовки.Получить("Last-Modified");
			Попытка
				ДеньИзм = Число(Сред(ДатаИзменен,6,2));
			Исключение
				Сообщить("Нет доступа к изображению на сайте.");
				НомерСтроки = НомерСтроки + 1;
				Продолжить;			
			КонецПопытки;
			МесяцИзм = ВернутьМесяц(Сред(ДатаИзменен,9,3));
			ГодИзм = Число(Сред(ДатаИзменен,13,4));
			
			НоваяСтрока = ТаблицаФайлов.Добавить();
			НоваяСтрока.Артикул = Артикул;
			НоваяСтрока.ДатаНаFTP = Дата(ГодИзм, МесяцИзм, ДеньИзм);
			НоваяСтрока.АдресИзображения = Изображение;
			
			НомерСтроки = НомерСтроки + 1;			
			
		Исключение
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка обработки строки: "+ПолученнаяСтрока);
			
		КонецПопытки;		
		
	КонецЦикла;
	
	Возврат ТаблицаФайлов;
	
КонецФункции // ТаблицаАдресовИзображенийИзСайта()

//Трегубов А.А. -- № 142456 --  10.11.2021
Процедура ВыполнитьЗагрузкуИзСайта(Объект,УникальныйИдентификаторФормы)
	
	//проверка состояния таблицы номенклатуры
	Если Объект.ТаблицаДляЗагрузки.Количество() = 0 Тогда
		Сообщить("Перед загрузкой изображений необходимо заполнить таблицу.");
		Возврат;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаНоменклатуры.Использовать
		|ПОМЕСТИТЬ ТаблицаНоменклатуры
		|ИЗ
		|	&ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
		|ГДЕ
		|	ТаблицаНоменклатуры.Использовать = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаНоменклатуры.Использовать
		|ИЗ
		|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры";
		
		Запрос.УстановитьПараметр("ТаблицаНоменклатуры",Объект.ТаблицаДляЗагрузки.Выгрузить());
		Выборка = Запрос.Выполнить().Выбрать();
		Если НЕ Выборка.Следующий() Тогда
			Сообщить("Выберите хотя бы одну строку в таблице для обновления изображения.");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураURI = СтруктураURI(Объект.HTTPСоединениеАдресСервераЗагрузки);
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост,СтруктураURI.Порт);
	
	Для Каждого СтрокаТаблицыДляЗагрузки Из Объект.ТаблицаДляЗагрузки Цикл
		
		Если НЕ СтрокаТаблицыДляЗагрузки.Использовать Тогда
			Продолжить;
		КонецЕсли;
		
		Если (Не ЗначениеЗаполнено(СтрокаТаблицыДляЗагрузки.Изображение)) ИЛИ (Не ЗначениеЗаполнено(СтрокаТаблицыДляЗагрузки.ДатаЗагрузки)) Тогда
			ЗагрузитьИзображениеНоменклатурыИзСайта(СтрокаТаблицыДляЗагрузки,HTTPСоединение,УникальныйИдентификаторФормы);
		Иначе
			Если СтрокаТаблицыДляЗагрузки.ДатаЗагрузки < СтрокаТаблицыДляЗагрузки.ДатаНаFTP Тогда
				ЗагрузитьИзображениеНоменклатурыИзСайта(СтрокаТаблицыДляЗагрузки,HTTPСоединение,УникальныйИдентификаторФормы);
			Иначе
				Сообщить("Для номенклатуры: " + СокрЛП(СтрокаТаблицыДляЗагрузки.Номенклатура.Наименование) + " обновление изображения не требуется.");
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьТаблицуДляЗагрузки(Объект);
	
КонецПроцедуры

//Трегубов А.А. -- № 142456 --  10.11.2021
Процедура ЗагрузитьИзображениеНоменклатурыИзСайта(СтрокаТаблицы,Соединение,УникальныйИдентификаторФормы)
	
	Попытка
		ВременныйКаталог 	= ?(Прав(КаталогВременныхФайлов(),1) = "\",КаталогВременныхФайлов(),КаталогВременныхФайлов() + "\");
		ПолноеИмяФайла 		= ВременныйКаталог + СокрЛП(СтрокаТаблицы.Артикул) + ".jpg";
		ИмяФайла 			= СокрЛП(СтрокаТаблицы.ДатаНаFTP) + "_" + СокрЛП(СтрокаТаблицы.Артикул) + ".jpg";	
		Соединение.Получить(СокрЛП(СтрокаТаблицы.АдресИзображения),ПолноеИмяФайла);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;

	ВладелецФайла = СтрокаТаблицы.Номенклатура;
	
	ОбщиеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами();
	
	Файл = Новый Файл(ПолноеИмяФайла);
	
	Если ОбщиеНастройки.ИзвлекатьТекстыФайловНаСервере Тогда
		АдресВременногоХранилищаТекста = "";
	Иначе
		АдресВременногоХранилищаТекста = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекстВоВременноеХранилище(ПолноеИмяФайла, );
	КонецЕсли;
	
	ВремяИзмененияУниверсальное = Файл.ПолучитьУниверсальноеВремяИзменения();
	
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолноеИмяФайла), УникальныйИдентификаторФормы);
	
	ПрисоединенныйФайл = ПрисоединенныеФайлыСлужебныйВызовСервера.ДобавитьФайл(ВладелецФайла,Файл.ИмяБезРасширения,
													ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(Файл.Расширение),,
													ВремяИзмененияУниверсальное,АдресВременногоХранилищаФайла,АдресВременногоХранилищаТекста);
	Попытка
		Номенклатура				= СтрокаТаблицы.Номенклатура.ПолучитьОбъект();
		Номенклатура.ФайлКартинки 	= ПрисоединенныйФайл;
		Номенклатура.Записать();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
													
КонецПроцедуры

//Трегубов А.А. -- № 142456 парсер из ЕИСФ --  10.11.2021
Функция ВернутьМесяц(МесяцНаим)
	
	Если МесяцНаим = "Jan" Тогда
		Возврат 1;
	ИначеЕсли МесяцНаим = "Feb" Тогда
		Возврат 2;
	ИначеЕсли МесяцНаим = "Mar" Тогда
		Возврат 3;
	ИначеЕсли МесяцНаим = "Apr" Тогда
		Возврат 4;
	ИначеЕсли МесяцНаим = "May" Тогда
		Возврат 5;
	ИначеЕсли МесяцНаим = "Jun" Тогда
		Возврат 6;
	ИначеЕсли МесяцНаим = "Jul" Тогда
		Возврат 7;
	ИначеЕсли МесяцНаим = "Aug" Тогда
		Возврат 8;
	ИначеЕсли МесяцНаим = "Sep" Тогда
		Возврат 9;
	ИначеЕсли МесяцНаим = "Oct" Тогда
		Возврат 10;
	ИначеЕсли МесяцНаим = "Nov" Тогда
		Возврат 11;
	ИначеЕсли МесяцНаим = "Dec" Тогда
		Возврат 12;
	КонецЕсли;
	
КонецФункции

//Трегубов А.А. -- № 142456 парсер из ЕИСФ --  10.11.2021
Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// строка соединения и путь на сервере
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// информация пользователя и имя сервера
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(Порт <> "", Число(Порт), Неопределено));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли