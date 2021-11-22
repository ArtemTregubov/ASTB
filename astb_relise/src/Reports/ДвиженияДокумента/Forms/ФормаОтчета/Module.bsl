
&НаСервере
Функция ОпределитьВидРегистра(МетаданныеРегистра)
	
	Если Метаданные.РегистрыНакопления.Индекс(МетаданныеРегистра) >= 0 Тогда
		Результат = "Накопления";
	ИначеЕсли Метаданные.РегистрыСведений.Индекс(МетаданныеРегистра) >= 0 Тогда
		Результат = "Сведений";
	ИначеЕсли Метаданные.РегистрыБухгалтерии.Индекс(МетаданныеРегистра) >= 0 Тогда
		Результат = "Бухгалтерии";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ДобавитьКолонкуВТаблицу(МетаданныеПоля, ТаблицаПолей)
	
	ТаблицаПолей.Колонки.Добавить(МетаданныеПоля.Имя, , МетаданныеПоля.Синоним);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКолонкуПериодВТаблицу(ТаблицаПолей)
	
	ТаблицаПолей.Колонки.Добавить("Период", , "Период");
	
КонецПроцедуры

&НаСервере
Процедура ПрисоединитьОбласть(ТабличныйДокумент, ОбластьМакета, Таблица)
	
	Для Каждого Колонка Из Таблица.Колонки Цикл
		
		ОбластьМакета.Параметры.ЗаголовокКолонки = Колонка.Заголовок;
		ТабличныйДокумент.Присоединить(ОбластьМакета);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, Область, СтрокаТаблицы)
	
	Для Каждого Колонка Из СтрокаТаблицы.Владелец().Колонки Цикл
		
		Область.Параметры.Значение = СтрокаТаблицы[Колонка.Имя];
		ТабличныйДокумент.Присоединить(Область);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПоДвижениям(МетаданныеРегистра, ВидРегистра)
	
	ТаблицаРесурсов    = Новый ТаблицаЗначений;
	ТаблицаИзмерений   = Новый ТаблицаЗначений;
	ТаблицаРеквизитов  = Новый ТаблицаЗначений;
	ТаблицаВидДвижений = Неопределено;
	
	СтруктураПолей = Новый Структура("Измерения, Реквизиты, Ресурсы",
	Новый Структура("СтрокаПолей, МассивРеквизитовАналитики", "", Новый Массив),
	Новый Структура("СтрокаПолей, МассивРеквизитовАналитики", "", Новый Массив),
	Новый Структура("СтрокаПолей, МассивРеквизитовАналитики", "", Новый Массив));
	
	НуженПериод = Не (ВидРегистра = "Сведений"
	И МетаданныеРегистра.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический);
	
	Если НуженПериод Тогда
		
		ИмяКоллекции = "Измерения";
		ИмяТаблицы   = ТаблицаИзмерений;
		
		ДобавитьКолонкуПериодВТаблицу(ТаблицаИзмерений);
		
		СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
		+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",") + "Период";
		
	КонецЕсли;
	
	ТекстСоединения   = "";
	ТекстПолейВыборки = "";
	
	Для Счетчик = 1 По 2 Цикл
		
		Если Счетчик = 1 Тогда
			ИмяКоллекции = "Измерения";
			ИмяТаблицы = ТаблицаИзмерений;
		Иначе
			ИмяКоллекции = "Реквизиты";
			ИмяТаблицы = ТаблицаРеквизитов;
		КонецЕсли;
		
		Для Каждого Измерение Из МетаданныеРегистра[ИмяКоллекции] Цикл
			
			ДобавитьКолонкуВТаблицу(Измерение, ИмяТаблицы);
			
			ТекстПоля = " ПРЕДСТАВЛЕНИЕССЫЛКИ(Таблица." + Измерение.Имя + " ) КАК " + Измерение.Имя +", ";
			
			СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
			+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",") + Измерение.Имя;
			
			ТекстПолейВыборки = ТекстПолейВыборки + Символы.ПС + ТекстПоля;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ИмяКоллекции = "Ресурсы";
	Для Каждого Ресурс Из МетаданныеРегистра[ИмяКоллекции] Цикл
		
		ТекстПолейВыборки = ТекстПолейВыборки + "
		|Таблица." + Ресурс.Имя + " КАК " + Ресурс.Имя +", ";
		
		СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
		+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",") + Ресурс.Имя;
		
		ДобавитьКолонкуВТаблицу(Ресурс, ТаблицаРесурсов);
		
	КонецЦикла;
	
	Если ВидРегистра = "Накопления"
		И МетаданныеРегистра.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
		
		ТаблицаВидДвижений = Новый ТаблицаЗначений;
		ТаблицаВидДвижений.Колонки.Добавить("ВидДвижения", , "Вид движения");
		
		ТекстПолейВыборки = ТекстПолейВыборки + "Таблица.ВидДвижения КАК ВидДвижения,";
		
	КонецЕсли;
	
	Если НуженПериод Тогда
		
		ТекстПолейВыборки = ТекстПолейВыборки + "Таблица.Период КАК Период,";
		
	КонецЕсли;
	
	ТекстПолейВыборки = ТекстПолейВыборки + "Таблица.НомерСтроки КАК НомерСтроки";
	
	ТекстЗапроса = 
	"
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|" + ТекстПолейВыборки + "
	|ИЗ
	|	" + МетаданныеРегистра.ПолноеИмя() + " КАК Таблица 
	|" + ТекстСоединения + "
	|ГДЕ
	|	Таблица.Регистратор = &Документ
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Новый Структура("ТекстЗапроса, СтруктураПолей, ТаблицаРесурсов, ТаблицаИзмерений, ТаблицаРеквизитов, ТаблицаВидДвижений",
	ТекстЗапроса, СтруктураПолей, ТаблицаРесурсов, ТаблицаИзмерений, ТаблицаРеквизитов, ТаблицаВидДвижений);
	
КонецФункции

&НаСервере
Функция ПолучитьЗначенияВСтроку(ВыбокаДанных, МассивПолей)
	
	Результат = "";
	Для Каждого ИмяПоля Из МассивПолей Цикл
		Если ЗначениеЗаполнено(ВыбокаДанных[ИмяПоля]) Тогда
			
			Результат = Результат + ?(ПустаяСтрока(Результат), "", "; ") + ВыбокаДанных[ИмяПоля];
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ВывестиДанныеПоРегистру(МетаданныеРегистра, Макет)
	
	ВидРегистра = ОпределитьВидРегистра(МетаданныеРегистра);
	
	Результат = ПолучитьДанныеПоДвижениям(МетаданныеРегистра, ВидРегистра);
	
	ТаблицаРесурсов    = Результат.ТаблицаРесурсов;
	ТаблицаИзмерений   = Результат.ТаблицаИзмерений;
	ТаблицаРеквизитов  = Результат.ТаблицаРеквизитов;
	ТаблицаВидДвижений = Результат.ТаблицаВидДвижений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Отчет.Документ);
	Запрос.Текст = Результат.ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ТаблицаВидДвижений <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаВидДвижений.Добавить(), Выборка, "ВидДвижения");
		КонецЕсли;
		
		СтрокаРесурсов   = ТаблицаРесурсов.Добавить();
		СтрокаИзмерений  = ТаблицаИзмерений.Добавить();
		СтрокаРеквизитов = ТаблицаРеквизитов.Добавить();
		
		Для Каждого ЭлементАналитики Из Результат.СтруктураПолей.Измерения.МассивРеквизитовАналитики Цикл
			
			СтрокаИзмерений[ЭлементАналитики.Поле] = ПолучитьЗначенияВСтроку(Выборка, ЭлементАналитики.МассивПолей);
			
		КонецЦикла;
		
		Для Каждого ЭлементАналитики Из Результат.СтруктураПолей.Реквизиты.МассивРеквизитовАналитики Цикл
			
			СтрокаРеквизитов[ЭлементАналитики.Поле] = ПолучитьЗначенияВСтроку(Выборка, ЭлементАналитики.МассивПолей);
			
		КонецЦикла;
		
		ЗаполнитьЗначенияСвойств(СтрокаРесурсов,   Выборка, Результат.СтруктураПолей.Ресурсы.СтрокаПолей);
		ЗаполнитьЗначенияСвойств(СтрокаИзмерений,  Выборка, Результат.СтруктураПолей.Измерения.СтрокаПолей);
		ЗаполнитьЗначенияСвойств(СтрокаРеквизитов, Выборка, Результат.СтруктураПолей.Реквизиты.СтрокаПолей);
		
	КонецЦикла;
	
	ЦветЗеленый = WebЦвета.Зеленый;
	ЦветКрасный = WebЦвета.Кирпичный;
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокОтчета");
	ОбластьЗаголовок.Параметры.СинонимРегистра = "Регистр " + НРег(ВидРегистра) + " """ + МетаданныеРегистра.Синоним + """";;
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	ТабличныйДокумент.НачатьГруппуСтрок();
	
	КоличествоСтрокРезультата = Выборка.Количество();
	
	Если СпособВыводаОтчета = Перечисления.СпособыВыводаОтчета.ПоГоризонтали Тогда
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокЯчейки");
		ОбластьЯчейка    = Макет.ПолучитьОбласть("Ячейка");
		ОбластьОтступ    = Макет.ПолучитьОбласть("Отступ1");
		
		ТабличныйДокумент.Вывести(ОбластьОтступ);
		
		Если ТаблицаВидДвижений <> Неопределено Тогда
			
			ОбластьЗаголовок.Параметры.ЗаголовокКолонки = "Вид движения";
			ТабличныйДокумент.Присоединить(ОбластьЗаголовок);
			
		КонецЕсли;
		
		ПрисоединитьОбласть(ТабличныйДокумент, ОбластьЗаголовок, ТаблицаИзмерений);
		ПрисоединитьОбласть(ТабличныйДокумент, ОбластьЗаголовок, ТаблицаРесурсов);
		ПрисоединитьОбласть(ТабличныйДокумент, ОбластьЗаголовок, ТаблицаРеквизитов);
		
		Для НомерСтроки = 1 По КоличествоСтрокРезультата Цикл
			
			ТабличныйДокумент.Вывести(ОбластьОтступ);
			Если ТаблицаВидДвижений <> Неопределено Тогда
				
				ОбластьЯчейка.Параметры.Значение = ТаблицаВидДвижений[НомерСтроки-1].ВидДвижения;
				ТабличныйДокумент.Присоединить(ОбластьЯчейка);
				
				Область = ТабличныйДокумент.Область("Ячейка");
				Область.ШиринаКолонки = 13;
				
				Если ТаблицаВидДвижений[НомерСтроки-1].ВидДвижения = ВидДвиженияНакопления.Расход Тогда
					Область.ЦветТекста = ЦветКрасный;
				Иначе
					Область.ЦветТекста = ЦветЗеленый;
				КонецЕсли;
				
			КонецЕсли;
			
			ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, ОбластьЯчейка, ТаблицаИзмерений[НомерСтроки-1]);
			ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, ОбластьЯчейка, ТаблицаРесурсов[НомерСтроки-1]);
			ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, ОбластьЯчейка, ТаблицаРеквизитов[НомерСтроки-1]);
			
		КонецЦикла;
	Иначе
		// Вывод таблицы
		
		Если ТаблицаВидДвижений <> Неопределено Тогда
			
			ОбластьШапки                  = Макет.ПолучитьОбласть("ШапкаТаблицы");
			ОбластьДеталиШапки            = Макет.ПолучитьОбласть("ДеталиШапки");
			ОбластьДетали                 = Макет.ПолучитьОбласть("Детали");
			ОбластьШапкиВидДвижения       = Макет.ПолучитьОбласть("ШапкаТаблицыВидДвижения");
			ОбластьДеталиШапкиВидДвижения = Макет.ПолучитьОбласть("ДеталиШапкиВидДвижения");
			ОбластьДеталиВидДвижения      = Макет.ПолучитьОбласть("ДеталиВидДвижения");
			ОбластьОтступ                 = Макет.ПолучитьОбласть("Отступ");
			
		Иначе
			
			ОбластьШапки       = Макет.ПолучитьОбласть("ШапкаТаблицы1");
			ОбластьДеталиШапки = Макет.ПолучитьОбласть("ДеталиШапки1");
			ОбластьДетали      = Макет.ПолучитьОбласть("Детали1");
			ОбластьОтступ      = Макет.ПолучитьОбласть("Отступ2");
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьОтступ);
		
		Если ТаблицаВидДвижений <> Неопределено Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкиВидДвижения);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапки);
		
		КоличествоКолонокШапки = Макс(ТаблицаРесурсов.Колонки.Количество(), ТаблицаИзмерений.Колонки.Количество(),
		ТаблицаРеквизитов.Колонки.Количество());
		ТонкаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,1);
		
		Для НомерСтроки = 1 По КоличествоКолонокШапки Цикл
			
			ОбластьДеталиШапки.Параметры.Ресурсы   = "";
			ОбластьДеталиШапки.Параметры.Измерения = "";
			ОбластьДеталиШапки.Параметры.Реквизиты = "";
			
			Если ТаблицаРесурсов.Колонки.Количество() >= НомерСтроки Тогда
				ОбластьДеталиШапки.Параметры.Ресурсы = ТаблицаРесурсов.Колонки[НомерСтроки-1].Заголовок;
				ОбластьДеталиШапки.Область(1,2,1,2).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);
			Иначе
				ОбластьДеталиШапки.Область(1,2,1,2).Обвести(ТонкаяЛиния,,ТонкаяЛиния,);
			КонецЕсли;
			
			Если ТаблицаИзмерений.Колонки.Количество() >= НомерСтроки Тогда
				ОбластьДеталиШапки.Параметры.Измерения = ТаблицаИзмерений.Колонки[НомерСтроки-1].Заголовок;
				ОбластьДеталиШапки.Область(1,1,1,1).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);
			Иначе
				ОбластьДеталиШапки.Область(1,1,1,1).Обвести(ТонкаяЛиния,,ТонкаяЛиния,);
			КонецЕсли;
			
			Если ТаблицаРеквизитов.Колонки.Количество() >= НомерСтроки Тогда
				ОбластьДеталиШапки.Параметры.Реквизиты = ТаблицаРеквизитов.Колонки[НомерСтроки-1].Заголовок;
				ОбластьДеталиШапки.Область(1,3,1,3).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);
			Иначе
				ОбластьДеталиШапки.Область(1,3,1,3).Обвести(ТонкаяЛиния,,ТонкаяЛиния,);
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьОтступ);
			Если ТаблицаВидДвижений <> Неопределено Тогда
				ТабличныйДокумент.Присоединить(ОбластьДеталиШапкиВидДвижения);
			КонецЕсли;
			
			ТабличныйДокумент.Присоединить(ОбластьДеталиШапки);
			
			Если НомерСтроки = КоличествоКолонокШапки Тогда
				Если ТаблицаВидДвижений <> Неопределено Тогда
					
					ТабличныйДокумент.Область("ДеталиШапкиВидДвижения").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);
					ТабличныйДокумент.Область("ДеталиШапки").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);
					
				Иначе
					
					ТабличныйДокумент.Область("ДеталиШапки1").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Для НомерСтроки = 1 По КоличествоСтрокРезультата Цикл
			
			ВыведенВидДвижения = Ложь;
			
			Для НомерКолонки = 1 По КоличествоКолонокШапки Цикл
				
				ОбластьДетали.Параметры.Ресурсы   = "";
				ОбластьДетали.Параметры.Измерения = "";
				ОбластьДетали.Параметры.Реквизиты = "";
				
				Если ТаблицаРесурсов.Колонки.Количество() >= НомерКолонки Тогда
					
					ИмяКолонки = ТаблицаРесурсов.Колонки[НомерКолонки-1].Имя;
					ОбластьДетали.Параметры.Ресурсы = ТаблицаРесурсов[НомерСтроки-1][ИмяКолонки];
					ОбластьДетали.Область(1,2,1,2).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);
					
				Иначе
					
					ОбластьДетали.Область(1,2,1,2).Обвести(ТонкаяЛиния,, ТонкаяЛиния,);
					
				КонецЕсли;
				
				Если ТаблицаИзмерений.Колонки.Количество() >= НомерКолонки Тогда
					
					ИмяКолонки = ТаблицаИзмерений.Колонки[НомерКолонки-1].Имя;
					ОбластьДетали.Параметры.Измерения = ТаблицаИзмерений[НомерСтроки-1][ИмяКолонки];
					ОбластьДетали.Область(1,1,1,1).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);
					
				Иначе
					
					ОбластьДетали.Область(1,1,1,1).Обвести(ТонкаяЛиния, , ТонкаяЛиния,);
					
				КонецЕсли;
				
				Если ТаблицаРеквизитов.Колонки.Количество() >= НомерКолонки Тогда
					
					ИмяКолонки = ТаблицаРеквизитов.Колонки[НомерКолонки-1].Имя;
					ОбластьДетали.Параметры.Реквизиты = ТаблицаРеквизитов[НомерСтроки-1][ИмяКолонки];
					ОбластьДетали.Область(1,3,1,3).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);
					
				Иначе
					
					ОбластьДетали.Область(1,3,1,3).Обвести(ТонкаяЛиния, , ТонкаяЛиния,);
					
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(ОбластьОтступ);
				
				Если ТаблицаВидДвижений <> Неопределено Тогда
					
					ВидДвижения = ?(ВыведенВидДвижения, "", ТаблицаВидДвижений[НомерСтроки-1]["ВидДвижения"]);
					
					ОбластьДеталиВидДвижения.Параметры.ВидДвижения = ВидДвижения;
					ТабличныйДокумент.Присоединить(ОбластьДеталиВидДвижения);
					
					Если Не ВыведенВидДвижения Тогда
						Если ВидДвижения = ВидДвиженияНакопления.Расход Тогда
							ТабличныйДокумент.Область("ДеталиВидДвижения").ЦветТекста = ЦветКрасный;
						Иначе
							ТабличныйДокумент.Область("ДеталиВидДвижения").ЦветТекста = ЦветЗеленый;
						КонецЕсли;
					КонецЕсли;
					
					ВыведенВидДвижения = Истина;
					
				КонецЕсли;
				
				ТабличныйДокумент.Присоединить(ОбластьДетали);
				
				Если НомерКолонки = КоличествоКолонокШапки Тогда
					Если ТаблицаВидДвижений <> Неопределено Тогда
						
						ТабличныйДокумент.Область("ДеталиВидДвижения").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);
						ТабличныйДокумент.Область("Детали").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);
						
					Иначе
						
						ТабличныйДокумент.Область("Детали1").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния)
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ТабличныйДокумент.ЗакончитьГруппуСтрок();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчет()
	
	Если Не ЗначениеЗаполнено(Отчет.Документ) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран документ'"), , , "Отчет.Документ");
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СпособВыводаОтчета) Тогда
		СпособВыводаОтчета = Перечисления.СпособыВыводаОтчета.ПоВертикали;
	КонецЕсли;
	
	ТабличныйДокумент.Очистить();
	
	Макет = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("Макет");
	
	МетаданныеДокумента = Отчет.Документ.Метаданные();
	МассивРегистров     = ПроведениеСервер.ПолучитьМассивИспользуемыхРегистров(Отчет.Документ, МетаданныеДокумента.Движения);
	
	Для Каждого МетаданныеРегистра Из МетаданныеДокумента.Движения Цикл
		
		Если МассивРегистров.Найти(МетаданныеРегистра.Имя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВывестиДанныеПоРегистру(МетаданныеРегистра, Макет);
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Документ", Отчет.Документ);
	
	Элементы.Документ.ТолькоПросмотр = ЗначениеЗаполнено(Отчет.Документ);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("СпособВыводаОтчета", СпособВыводаОтчета);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Значение = Настройки.Получить("СпособВыводаОтчета");
	Если Значение <> Неопределено Тогда
		СпособВыводаОтчета = Значение;
	Иначе
		Если НЕ ЗначениеЗаполнено(Значение) Тогда
			СпособВыводаОтчета = Перечисления.СпособыВыводаОтчета.ПоВертикали;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.Документ) Тогда
		
		СформироватьОтчет();
		ОтчетСформирован = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВыполнить()
	
	ОчиститьСообщения();
	
	СформироватьОтчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ОтчетСформирован И ЗначениеЗаполнено(Отчет.Документ) Тогда
		
		СформироватьОтчет();
		ОтчетСформирован = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
