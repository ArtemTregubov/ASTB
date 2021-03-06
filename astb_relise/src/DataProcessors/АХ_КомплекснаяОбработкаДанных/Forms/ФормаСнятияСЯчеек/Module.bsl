#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Документ",Документ) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(нСтр("ru='Данная форма должна вызываться из документа'", "ru"),,,,Отказ);
		Возврат;
	КонецЕсли;
	
	ТаблицаТоваров.Загрузить(ТаблицаТоваровПоДокументуВМезонине(Документ));
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	СтруктураПоиска = Новый Структура("Пометка",Истина);
	
	МассивНайденныхСтрок = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	Если МассивНайденныхСтрок.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(нСтр("ru='Для отправки данных необходимо выбрать отправляемые строки'", "ru"),,,,Отказ);
	КонецЕсли;
	
	СтруктураПоиска.Вставить("Количество",0);
	
	МассивНайденныхСтрок = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(нСтр("ru='Обнаружены строки с пустым количеством'", "ru"),,,,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьПланСнятия(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		МассивДанных = СформироватьМассивДанныхДляОтправки(); 
		
		СтруктураОбработкиОшибок = АХ_ОбменКлиент.ИнициализироватьСтруктуруОбработкиОшибок();
		Если НЕ АХ_ОбменКлиент.ПередатьДанныеВАдресноеХранение(МассивДанных,Ложь,СтруктураОбработкиОшибок,Документ) Тогда 		
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ТаблицаТоваровПоДокументуВМезонине(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АХ_ДанныеВАдресномХранении.Номенклатура КАК Номенклатура,
		|	АХ_ДанныеВАдресномХранении.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	АХ_ДанныеВАдресномХранении.Количество КАК Количество,
		|	АХ_ДанныеВАдресномХранении.Количество КАК КоличествоДоступно
		|ИЗ
		|	РегистрСведений.АХ_ДанныеВАдресномХранении КАК АХ_ДанныеВАдресномХранении
		|ГДЕ
		|	АХ_ДанныеВАдресномХранении.Документ = &Документ
		|	И АХ_ДанныеВАдресномХранении.ВидАдресногоДокумента = ЗНАЧЕНИЕ(Перечисление.АХ_ВидыДокументовАдресногоХранения.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

&НаСервере
Функция СформироватьМассивДанныхДляОтправки()
	
	ИнициализированныеДанные = АХ_ОбменПравилаВыгрузки.ИнициализироватьДанныеКОтправкеПланаСнятия(); 

	СтруктураПриоритетныхданных = Новый Структура("СборкаСМезонина,Товары");
	ЗаполнитьЗначенияСвойств(СтруктураПриоритетныхданных,ИнициализированныеДанные);
	
	СтруктураПриоритетныхданных.СборкаСМезонина = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ТаблицаТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ТаблицаТовары.Количество КАК Количество,
		|	ТаблицаТовары.Пометка КАК Пометка
		|ПОМЕСТИТЬ ВТ_Товары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Товары.Номенклатура КАК Номенклатура,
		|	ВТ_Товары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ВТ_Товары.Количество КАК Количество
		|ИЗ
		|	ВТ_Товары КАК ВТ_Товары
		|ГДЕ
		|	ВТ_Товары.Пометка";
	
	Запрос.УстановитьПараметр("ТаблицаТовары",ТаблицаТоваров.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() цикл
		
		НоваяСтрокаТовары = СтруктураПриоритетныхДанных.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТовары,Выборка);
		
	КонецЦикла;
			
	ПередаваемыеДанные = Новый Структура;
	ПередаваемыеДанные.Вставить("Источник",Документ);
	ПередаваемыеДанные.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(СтруктураПриоритетныхданных,ЭтаФорма.УникальныйИдентификатор));
	
	//СтруктураПередаваемыхДанных = Новый Структура("Параметры",ПередаваемыеДанные);
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("ВыборочнаяПередачаДанныхВПланСнятияСМезонина",ПередаваемыеДанные);
	
	МассивПередачи = Новый Массив;
	МассивПередачи.Добавить(Соответствие);
	
	Возврат МассивПередачи;
		
КонецФункции // СформироватьМассивДанныхДляОтправки()

&НаКлиенте
Процедура ТаблицаТоваровПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекущиеДанные = Элементы.ТаблицаТоваров.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.Количество > ТекущиеДанные.КоличествоДоступно Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(нСтр("ru='Доступно к передаче " + ТекущиеДанные.КоличествоДоступно + " '", "ru"),,,,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы
#КонецОбласти