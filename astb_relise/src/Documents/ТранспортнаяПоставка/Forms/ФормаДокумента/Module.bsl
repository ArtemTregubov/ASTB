////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект,НОВЫЙ Структура("ИмяЭлементаДляРазмещения","ГруппаДополнительныеРеквизиты"));
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
 	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВА"

// СтандартныеПодсистемы.Свойства
 &НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "ПЕЧАТЬ"

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
  УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
  
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ...

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗагрузитьТранспортнуюПоставку(Команда)
	
	ПриЗавершении = Новый ОписаниеОповещения("ВыборФайловТранспортнойПоставкиЗавершение", ЭтотОбъект);
	
	ДиалогВыбораФайлов 					  = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайлов.МножественныйВыбор = Истина;	
	ДиалогВыбораФайлов.Заголовок 		  = "Выбор файлов для загрузки";
	ДиалогВыбораФайлов.Фильтр 			  = "Упаковочный лист|*.xml";
	
	НачатьПомещениеФайлов(ПриЗавершении, ДиалогВыбораФайлов, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайловТранспортнойПоставкиЗавершение(МассивФайлов,Параметры) экспорт
	
	Если МассивФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстКомментария = "Источники загрузки: ";
	
	Для каждого Элемент из МассивФайлов Цикл	
		
		Адрес = Элемент.Хранение;	
		Имя = Элемент.Имя;
		
		ТекстКомментария = ТекстКомментария + Символы.ПС + Элемент.Имя;
		
		ЗагрузитьТранспортнуюПоставкуНаСервере(Адрес,Имя);
		
	КонецЦикла;
	
	Объект.Комментарий = ТекстКомментария;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДокументПоступления(НомерДокумента,ДатаДокумента)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеНоменклатуры.Ссылка КАК ДокументПоступления
	|ИЗ
	|	Документ.ПоступлениеНоменклатуры КАК ПоступлениеНоменклатуры
	|ГДЕ
	|	ПоступлениеНоменклатуры.Организация = &Организация
	|	И ПоступлениеНоменклатуры.Поставщик = &Поставщик
	|	И ПоступлениеНоменклатуры.НомерВходящегоДокумента = &НомерВходящегоДокумента
	|	И ПоступлениеНоменклатуры.ДатаВходящегоДокумента = &ДатаВходящегоДокумента";
	
	Запрос.УстановитьПараметр("Организация",			Объект.Организация);
	Запрос.УстановитьПараметр("Поставщик",				Объект.Поставщик);
	Запрос.УстановитьПараметр("НомерВходящегоДокумента",НомерДокумента);
	Запрос.УстановитьПараметр("ДатаВходящегоДокумента",	ДатаДокумента);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Документы.ПоступлениеНоменклатуры.ПустаяСсылка();
	Иначе
		Возврат Результат.Выгрузить()[0].ДокументПоступления;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьДату(ЗначениеДаты)
	
	Если ТипЗнч(ЗначениеДаты) = Тип("Число") Тогда
		
		ИсходнаяДата = Дата('19000101');
		
		Если ЗначениеДаты > 60 Тогда
			ЧислоСекунд = (ЗначениеДаты - 2) * 60 * 60 * 24;
			Возврат ИсходнаяДата + ЧислоСекунд;
		Иначе
			ЧислоСекунд = (ЗначениеДаты - 1) * 60 * 60 * 24;
			Возврат ИсходнаяДата + ЧислоСекунд;
		КонецЕсли;
		
	Иначе
		
		Возврат Дата(Прав(СокрЛП(ЗначениеДаты),4),Сред(СокрЛП(ЗначениеДаты),4,2),Лев(СокрЛП(ЗначениеДаты),2));
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьТранспортнуюПоставкуНаСервере(АдресХранения,Имя)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Контрагенты.Ссылка КАК Поставщик
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ИНН = &ИНН
	|	И Контрагенты.КПП = &КПП";
	
	ИмяФайлаХМЛ = ПолучитьИмяВременногоФайла("xml");
	Файл   		= ПолучитьИзВременногоХранилища(АдресХранения);
	
	Файл.Записать(ИмяФайлаХМЛ);
	
	Чтение = Новый ЧтениеXML();
	Чтение.ОткрытьФайл(ИмяФайлаХМЛ);
	
	ТаблицаНоменклатуры = Новый ТаблицаЗначений;
	ТаблицаНоменклатуры.Колонки.Добавить("КодОракл", 			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0)));
	ТаблицаНоменклатуры.Колонки.Добавить("КодХарактеристики", 	Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0)));
	ТаблицаНоменклатуры.Колонки.Добавить("Количество", 			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3)));
	ТаблицаНоменклатуры.Колонки.Добавить("ШтрихКодКороба", 		Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)));
	
	ТаблицаКоробов = Новый ТаблицаЗначений;
	ТаблицаКоробов.Колонки.Добавить("ШтрихКод", 			Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)));
	ТаблицаКоробов.Колонки.Добавить("НомерДокумента", 		Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)));
	ТаблицаКоробов.Колонки.Добавить("ДатаДокумента", 		Новый ОписаниеТипов("Дата"));
	ТаблицаКоробов.Колонки.Добавить("ДокументПоступления", 	Новый ОписаниеТипов("ДокументСсылка.ПоступлениеНоменклатуры"));
	ТаблицаКоробов.Колонки.Добавить("Сборный", 				Новый ОписаниеТипов("Булево"));
	
	ТаблицаТоваровДокумента = Объект.Товары.Выгрузить();
	ТаблицаКоробовДокумента = Объект.Короба.Выгрузить();

	НомерДокумента = "";
		
	Пока Чтение.Прочитать() Цикл
		
		Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
									
			Если Чтение.ЛокальноеИмя = "document_item" Тогда
				
				НомерДокумента	= Чтение.ЗначениеАтрибута("doc_number");
				ДатаДокумента 	= ПолучитьДату(Чтение.ЗначениеАтрибута("doc_date"));
				ИННПоставщика 	= Чтение.ЗначениеАтрибута("seller_inn");
				КПППоставщика 	= Чтение.ЗначениеАтрибута("seller_kpp");
				
				Если НЕ ЗначениеЗаполнено(Объект.Поставщик) Тогда
					
					Запрос.УстановитьПараметр("ИНН",ИННПоставщика);
					Запрос.УстановитьПараметр("КПП",КПППоставщика);
					
					Выборка = Запрос.Выполнить().Выбрать();
					
					Если Выборка.Следующий() Тогда
						Объект.Поставщик = Выборка.Поставщик;
					КонецЕсли;
					
				КонецЕсли;	
				
				ДокументПоступления = ПолучитьДокументПоступления(НомерДокумента,ДатаДокумента);
				
			ИначеЕсли Чтение.ЛокальноеИмя = "box_item" Тогда
				
				ШтрихКодУпаковки = Чтение.ЗначениеАтрибута("box_code");
				
				Если ШтрихКодУпаковки = Неопределено Тогда
					
					СообщениеПользователю = Новый СообщениеПользователю;
					СообщениеПользователю.Текст = "В файле: " + ИмяФайлаХМЛ + " не найдена информация об одном из коробов. Перешлите данный файл сотрудникам ЦО." + Символы.ПС + "Информация из этого файла загружена не будет";
					СообщениеПользователю.Сообщить();
					
				Иначе
					
					Заводской = Число(Чтение.ЗначениеАтрибута("factory"));
					
					НоваяСтрока = ТаблицаКоробов.Добавить();
					НоваяСтрока.ШтрихКод 			= ШтрихКодУпаковки;
					НоваяСтрока.НомерДокумента 		= НомерДокумента;
					НоваяСтрока.ДатаДокумента 		= ДатаДокумента;
					НоваяСтрока.ДокументПоступления = ДокументПоступления;
					НоваяСтрока.Сборный 			= ?(Заводской = 1, Ложь, Истина);
					
				КонецЕсли;
 	
			ИначеЕсли Чтение.ЛокальноеИмя = "nomenclature_item" Тогда
				
				ЕстьОшибки = Ложь;
				
				Количество 					= Число(Чтение.ЗначениеАтрибута("number"));
				КодХарактеристики 			= Чтение.ЗначениеАтрибута("size_code");
				НаименованиеНоменклатуры 	= Чтение.ЗначениеАтрибута("tov_name40"); 
			
				Попытка
					КодНоменклатуры = Число(Чтение.ЗначениеАтрибута("nomenclature_code"));
				Исключение
					СообщениеПользователю = Новый СообщениеПользователю;
					СообщениеПользователю.Текст = "Ошибка при чтении кода оракл: " +Чтение.ЗначениеАтрибута("nomenclature_code") + "! Загрузка невозможна!";
					СообщениеПользователю.Сообщить();
					ЕстьОшибки = Истина;
				КонецПопытки;
				
				Если ЗначениеЗаполнено(КодХарактеристики) Тогда
					
					Попытка
						КодХарактеристики = Число(КодХарактеристики);
					Исключение
						СообщениеПользователю = Новый СообщениеПользователю;
						СообщениеПользователю.Текст = "Ошибка при чтении кода характеристики: " + КодХарактеристики + "! Загрузка невозможна!";
						СообщениеПользователю.Сообщить();
						ЕстьОшибки = Истина;
					КонецПопытки;	
					
				Иначе
					
					КодХарактеристики = 0;
					
				КонецЕсли;
				
				Если НЕ ЕстьОшибки Тогда
					НоваяСтрока = ТаблицаНоменклатуры.Добавить();
					НоваяСтрока.КодОракл 			= КодНоменклатуры;
					НоваяСтрока.КодХарактеристики 	= КодХарактеристики;
					НоваяСтрока.Количество 			= Количество;
					НоваяСтрока.ШтрихКодКороба 		= ШтрихКодУпаковки;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаКоробов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаКоробов.Штрихкод КАК Штрихкод,
	|	ТаблицаКоробов.НомерДокумента КАК НомерДокумента,
	|	ТаблицаКоробов.ДатаДокумента КАК ДатаДокумента,
	|	ТаблицаКоробов.ДокументПоступления КАК ДокументПоступления,
	|	ТаблицаКоробов.Сборный КАК Сборный
	|ПОМЕСТИТЬ ВТ_ТаблицаКоробов
	|ИЗ
	|	&ТаблицаКоробов КАК ТаблицаКоробов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаНоменклатуры.КодОракл КАК КодОракл,
	|	ТаблицаНоменклатуры.КодХарактеристики КАК КодХарактеристики,
	|	ТаблицаНоменклатуры.Количество КАК Количество,
	|	ТаблицаНоменклатуры.ШтрихКодКороба КАК ШтрихКодКороба
	|ПОМЕСТИТЬ ВТ_ТаблицаНоменклатуры
	|ИЗ
	|	&ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваровДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваровДокумента.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТаблицаТоваровДокумента.Количество КАК Количество,
	|	ТаблицаТоваровДокумента.Короб КАК Короб
	|ПОМЕСТИТЬ ВТ_ТаблицаТоваровДокумента
	|ИЗ
	|	&ТаблицаТоваровДокумента КАК ТаблицаТоваровДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКоробовДокумента.Короб КАК Короб,
	|	ТаблицаКоробовДокумента.НомерДокумента КАК НомерДокумента,
	|	ТаблицаКоробовДокумента.ДатаДокумента КАК ДатаДокумента,
	|	ТаблицаКоробовДокумента.ДокументПоступления КАК ДокументПоступления
	|ПОМЕСТИТЬ ВТ_ТаблицаКоробовДокумента
	|ИЗ
	|	&ТаблицаКоробовДокумента КАК ТаблицаКоробовДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Короба.Ссылка КАК Короб,
	|	Короба.Код КАК Код,
	|	Короба.Сборный КАК Сборный
	|ПОМЕСТИТЬ ВТ_Короба
	|ИЗ
	|	Справочник.Короба КАК Короба
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	Номенклатура.КодСинхронизации КАК КодСинхронизации
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	НЕ Номенклатура.ЭтоГруппа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Владелец КАК Номенклатура,
	|	ХарактеристикиНоменклатуры.Ссылка КАК ХарактеристикаНоменкллатуры,
	|	ХарактеристикиНоменклатуры.Код КАК КодХарактеристики
	|ПОМЕСТИТЬ ВТ_ХарактеристикиНоменклатуры
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаНоменклатуры.КодОракл КАК КодОракл,
	|	ВТ_ТаблицаНоменклатуры.КодХарактеристики КАК КодХарактеристики,
	|	ВТ_ТаблицаНоменклатуры.Количество КАК Количество,
	|	ВТ_ТаблицаНоменклатуры.ШтрихКодКороба КАК ШтрихКодКороба,
	|	ВТ_Номенклатура.Номенклатура КАК Номенклатура,
	|	ВТ_Короба.Короб КАК Короб
	|ПОМЕСТИТЬ ВТ_НоменклатураБезХарактеристик
	|ИЗ
	|	ВТ_ТаблицаНоменклатуры КАК ВТ_ТаблицаНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Номенклатура КАК ВТ_Номенклатура
	|		ПО ВТ_ТаблицаНоменклатуры.КодОракл = ВТ_Номенклатура.КодСинхронизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Короба КАК ВТ_Короба
	|		ПО ВТ_ТаблицаНоменклатуры.ШтрихКодКороба = ВТ_Короба.Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НоменклатураБезХарактеристик.КодОракл КАК КодОракл,
	|	ВТ_НоменклатураБезХарактеристик.КодХарактеристики КАК КодХарактеристики,
	|	ВТ_НоменклатураБезХарактеристик.Количество КАК Количество,
	|	ВТ_НоменклатураБезХарактеристик.ШтрихКодКороба КАК ШтрихКодКороба,
	|	ВТ_НоменклатураБезХарактеристик.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ВТ_НоменклатураБезХарактеристик.КодХарактеристики = 0
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|		ИНАЧЕ ЕСТЬNULL(ВТ_ХарактеристикиНоменклатуры.ХарактеристикаНоменкллатуры, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|	КОНЕЦ КАК ХарактеристикаНоменклатуры,
	|	ВТ_НоменклатураБезХарактеристик.Короб КАК Короб
	|ПОМЕСТИТЬ ВТ_СобраннаяТаблицаТоваров
	|ИЗ
	|	ВТ_НоменклатураБезХарактеристик КАК ВТ_НоменклатураБезХарактеристик
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ХарактеристикиНоменклатуры КАК ВТ_ХарактеристикиНоменклатуры
	|		ПО ВТ_НоменклатураБезХарактеристик.Номенклатура = ВТ_ХарактеристикиНоменклатуры.Номенклатура
	|			И ВТ_НоменклатураБезХарактеристик.КодХарактеристики = ВТ_ХарактеристикиНоменклатуры.КодХарактеристики
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	"""",
	|	"""",
	|	ВТ_ТаблицаТоваровДокумента.Количество,
	|	"""",
	|	ВТ_ТаблицаТоваровДокумента.Номенклатура,
	|	ВТ_ТаблицаТоваровДокумента.ХарактеристикаНоменклатуры,
	|	ВТ_ТаблицаТоваровДокумента.Короб
	|ИЗ
	|	ВТ_ТаблицаТоваровДокумента КАК ВТ_ТаблицаТоваровДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТаблицаКоробов.Штрихкод КАК Штрихкод,
	|	ВТ_ТаблицаКоробов.НомерДокумента КАК НомерДокумента,
	|	ВТ_ТаблицаКоробов.Сборный КАК Сборный,
	|	ВТ_Короба.Короб КАК Короб,
	|	ВТ_ТаблицаКоробов.ДатаДокумента КАК ДатаДокумента,
	|	ВТ_ТаблицаКоробов.ДокументПоступления КАК ДокументПоступления
	|ПОМЕСТИТЬ ВТ_КоробаРезультат
	|ИЗ
	|	ВТ_ТаблицаКоробов КАК ВТ_ТаблицаКоробов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Короба КАК ВТ_Короба
	|		ПО ВТ_ТаблицаКоробов.Штрихкод = ВТ_Короба.Код
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Короба.Короб.Код,
	|	ВТ_ТаблицаКоробовДокумента.НомерДокумента,
	|	ВТ_Короба.Сборный,
	|	ВТ_ТаблицаКоробовДокумента.Короб,
	|	ВТ_ТаблицаКоробовДокумента.ДатаДокумента,
	|	ВТ_ТаблицаКоробовДокумента.ДокументПоступления
	|ИЗ
	|	ВТ_ТаблицаКоробовДокумента КАК ВТ_ТаблицаКоробовДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Короба КАК ВТ_Короба
	|		ПО ВТ_ТаблицаКоробовДокумента.Короб = ВТ_Короба.Короб
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_КоробаРезультат.Штрихкод КАК Штрихкод,
	|	ВТ_КоробаРезультат.НомерДокумента КАК НомерДокумента,
	|	ВТ_КоробаРезультат.Сборный КАК Сборный,
	|	ВТ_КоробаРезультат.Короб КАК Короб,
	|	ВТ_КоробаРезультат.ДатаДокумента КАК ДатаДокумента,
	|	МАКСИМУМ(ВТ_КоробаРезультат.ДокументПоступления) КАК ДокументПоступления
	|ИЗ
	|	ВТ_КоробаРезультат КАК ВТ_КоробаРезультат
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_КоробаРезультат.Штрихкод,
	|	ВТ_КоробаРезультат.НомерДокумента,
	|	ВТ_КоробаРезультат.Сборный,
	|	ВТ_КоробаРезультат.Короб,
	|	ВТ_КоробаРезультат.ДатаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерДокумента,
	|	ДатаДокумента,
	|	Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СобраннаяТаблицаТоваров.КодОракл КАК КодОракл,
	|	ВТ_СобраннаяТаблицаТоваров.КодХарактеристики КАК КодХарактеристики,
	|	СУММА(ВТ_СобраннаяТаблицаТоваров.Количество) КАК Количество,
	|	ВТ_СобраннаяТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВТ_СобраннаяТаблицаТоваров.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВТ_СобраннаяТаблицаТоваров.Короб КАК Короб,
	|	ВТ_СобраннаяТаблицаТоваров.ШтрихКодКороба КАК ШтрихКодКороба
	|ИЗ
	|	ВТ_СобраннаяТаблицаТоваров КАК ВТ_СобраннаяТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_СобраннаяТаблицаТоваров.КодОракл,
	|	ВТ_СобраннаяТаблицаТоваров.КодХарактеристики,
	|	ВТ_СобраннаяТаблицаТоваров.Номенклатура,
	|	ВТ_СобраннаяТаблицаТоваров.ХарактеристикаНоменклатуры,
	|	ВТ_СобраннаяТаблицаТоваров.Короб,
	|	ВТ_СобраннаяТаблицаТоваров.ШтрихКодКороба
	|
	|УПОРЯДОЧИТЬ ПО
	|	ШтрихКодКороба,
	|	ВТ_СобраннаяТаблицаТоваров.Номенклатура.Наименование,
	|	ВТ_СобраннаяТаблицаТоваров.ХарактеристикаНоменклатуры.КодSAP";
	
	Запрос.УстановитьПараметр("ТаблицаКоробов",			ТаблицаКоробов);
	Запрос.УстановитьПараметр("ТаблицаНоменклатуры",	ТаблицаНоменклатуры);
	Запрос.УстановитьПараметр("ТаблицаТоваровДокумента",ТаблицаТоваровДокумента);
	Запрос.УстановитьПараметр("ТаблицаКоробовДокумента",ТаблицаКоробовДокумента);
	Запрос.УстановитьПараметр("ДатаАнализа",			ПроцедурыРаботыСНормамиСервер.ПолучитьГраницуАнализаПоДокументу(Объект.Ссылка));
	Запрос.УстановитьПараметр("Организация",			Объект.Организация);
	Запрос.УстановитьПараметр("Поставщик",				Объект.Поставщик);
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаКоробов 		= Результат[10].Выгрузить();
	ТаблицаНоменклатуры = Результат[11].Выгрузить();
	
	ТаблицаТоваровДокумента.Очистить();
	ТаблицаКоробовДокумента.Очистить();
	
	//заполнение таблицы коробов
	Для Каждого СтрокаТаблицыКоробов Из ТаблицаКоробов Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицыКоробов.Короб) Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаКоробовДокумента.Добавить(),СтрокаТаблицыКоробов);
		Иначе
			НовыйКороб = Справочники.Короба.СоздатьЭлемент();
			Новыйкороб.Код 		= СтрокаТаблицыКоробов.ШтрихКод;
			НовыйКороб.Сборный  = СтрокаТаблицыКоробов.Сборный;
			НовыйКороб.Записать();
			СтрокаТаблицыКоробов.Короб = НовыйКороб.Ссылка;
			ЗаполнитьЗначенияСвойств(ТаблицаКоробовДокумента.Добавить(),СтрокаТаблицыКоробов);
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаКоробовДокумента.Свернуть("Короб, НомерДокумента, ДатаДокумента, ДокументПоступления");
	
	Объект.Короба.Загрузить(ТаблицаКоробовДокумента);
	
	ТаблицаОшибок = Новый ТаблицаЗначений;
	ТаблицаОшибок.Колонки.Добавить("ОписаниеОшибки");
	
	//заполнение таблицы товаров
	Для Каждого СтрокаТаблицыНоменклатуры Из ТаблицаНоменклатуры Цикл
		
		ЕстьОшибки = Ложь;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыНоменклатуры.Номенклатура) Тогда
			НоваяСтрока = ТаблицаОшибок.Добавить();
			НоваяСтрока.ОписаниеОшибки = "Не найдена номенклатура по коду: " + СтрокаТаблицыНоменклатуры.КодОракл + "!";
			ЕстьОшибки = Истина;
		КонецЕсли;	
		
		Если НЕ ЕстьОшибки И ЗначениеЗаполнено(СтрокаТаблицыНоменклатуры.КодХарактеристики) И НЕ ЗначениеЗаполнено(СтрокаТаблицыНоменклатуры.ХарактеристикаНоменклатуры) Тогда
			НоваяСтрока = ТаблицаОшибок.Добавить();
			НоваяСтрока.ОписаниеОшибки = "Не найдена характеристика номенклатуры (" + СтрокаТаблицыНоменклатуры.КодОракл + ") по коду: " + СтрокаТаблицыНоменклатуры.КодХарактеристики + "!";
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицыНоменклатуры.Короб) Тогда
			Короб = Справочники.Короба.НайтиПоКоду(СтрокаТаблицыНоменклатуры.ШтрихКодКороба);
			СтрокаТаблицыНоменклатуры.Короб = Короб;
		КонецЕсли;
		
		Если НЕ ЕстьОшибки Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаТоваровДокумента.Добавить(),СтрокаТаблицыНоменклатуры);
		КонецЕсли;	
						
	КонецЦикла;
	
	//заполнение состава коробов
	Для Каждого СтрокаТаблицыНоменклатуры Из ТаблицаНоменклатуры Цикл
		
		Короб = СтрокаТаблицыНоменклатуры.Короб.ПолучитьОбъект();
		Короб.Состав.Очистить();
		ЗаполнитьЗначенияСвойств(Короб.Состав.Добавить(),СтрокаТаблицыНоменклатуры);
		Короб.Записать();
		
	КонецЦикла;	
	
	ТаблицаОшибок.Свернуть("ОписаниеОшибки");
	
	Для Каждого СтрокаТаблицыОшибок Из ТаблицаОшибок Цикл
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = СтрокаТаблицыОшибок.ОписаниеОшибки;
		СообщениеПользователю.Сообщить();
		
	КонецЦикла;
	
	ТаблицаТоваровДокумента.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, Количество, Короб");
	
	Объект.Товары.Загрузить(ТаблицаТоваровДокумента);
	
	Модифицированность = Истина;
	
КонецПроцедуры