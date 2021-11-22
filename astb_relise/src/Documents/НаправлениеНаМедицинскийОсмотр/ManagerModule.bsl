#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Направление") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"Направление",
			"Направление на медицинский осмотр",
			СформироватьПечатнуюФормуНаправления(МассивОбъектов, ОбъектыПечати),,"Документ.НаправлениеНаМедицинскийОсмотр.ПФ_MXL_НаправлениеНаМедицинскийОсмотр");
				
	КонецЕсли;		
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуНаправления(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_НаправлениеНаМедицинскийОсмотр_Направление";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОсновноеМестоРаботыСотрудника.Период КАК Период,
	|	ОсновноеМестоРаботыСотрудника.Сотрудник КАК Сотрудник,
	|	ОсновноеМестоРаботыСотрудника.Подразделение КАК Подразделение,
	|	ОсновноеМестоРаботыСотрудника.МоментВремени КАК МоментВремени,
	|	ОсновноеМестоРаботыСотрудника.ОсновноеМестоРаботы КАК ОсновноеМестоРаботы,
	|	ОсновноеМестоРаботыСотрудника.Должность КАК Должность,
	|	ОсновноеМестоРаботыСотрудника.РабочееМесто КАК РабочееМесто
	|ПОМЕСТИТЬ ВТ_ОсновныеМестаРаботыСотрудников
	|ИЗ
	|	РегистрСведений.ОсновноеМестоРаботыСотрудника КАК ОсновноеМестоРаботыСотрудника
	|ГДЕ
	|	ОсновноеМестоРаботыСотрудника.Активность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Сотрудник КАК Сотрудник,
	|	ВложенныйЗапрос.Подразделение КАК Подразделение,
	|	ВложенныйЗапрос.Период КАК НачалоПериода,
	|	МИНИМУМ(ЕСТЬNULL(ВТ_ОсновныеМестаРаботыСотрудников.Период, &Период)) КАК КонецПериода,
	|	ВложенныйЗапрос.Должность КАК Должность,
	|	ВложенныйЗапрос.РабочееМесто КАК РабочееМесто
	|ПОМЕСТИТЬ ВТ_ПериодыРаботыСотрудников
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_ОсновныеМестаРаботыСотрудников.Период КАК Период,
	|		ВТ_ОсновныеМестаРаботыСотрудников.Сотрудник КАК Сотрудник,
	|		ВТ_ОсновныеМестаРаботыСотрудников.Подразделение КАК Подразделение,
	|		ВТ_ОсновныеМестаРаботыСотрудников.МоментВремени КАК МоментВремени,
	|		ВТ_ОсновныеМестаРаботыСотрудников.Должность КАК Должность,
	|		ВТ_ОсновныеМестаРаботыСотрудников.РабочееМесто КАК РабочееМесто
	|	ИЗ
	|		ВТ_ОсновныеМестаРаботыСотрудников КАК ВТ_ОсновныеМестаРаботыСотрудников
	|	ГДЕ
	|		ВТ_ОсновныеМестаРаботыСотрудников.ОсновноеМестоРаботы) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОсновныеМестаРаботыСотрудников КАК ВТ_ОсновныеМестаРаботыСотрудников
	|		ПО ВложенныйЗапрос.Сотрудник = ВТ_ОсновныеМестаРаботыСотрудников.Сотрудник
	|			И ВложенныйЗапрос.МоментВремени < ВТ_ОсновныеМестаРаботыСотрудников.МоментВремени
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Сотрудник,
	|	ВложенныйЗапрос.Подразделение,
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.Должность,
	|	ВложенныйЗапрос.РабочееМесто
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Период КАК Период,
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Организация КАК Организация,
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Подразделение КАК Подразделение,
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.МоментВремени КАК МоментВремени,
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.ФакторИлиРабота КАК ФакторИлиРабота,
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Должность КАК Должность,
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.РабочееМесто КАК РабочееМесто,
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.ФакторРабота КАК ФакторРабота
	|ПОМЕСТИТЬ ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах
	|ИЗ
	|	РегистрСведений.ВредныеИОпасныеФакторыИРаботыНаРабочихМестах КАК ВредныеИОпасныеФакторыИРаботыНаРабочихМестах
	|ГДЕ
	|	ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Активность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.Подразделение КАК Подразделение,
	|	ВложенныйЗапрос.Период КАК НачалоПериода,
	|	МИНИМУМ(ЕСТЬNULL(ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Период, &Период)) КАК КонецПериода,
	|	ВложенныйЗапрос.Должность КАК Должность,
	|	ВложенныйЗапрос.РабочееМесто КАК РабочееМесто,
	|	ВложенныйЗапрос.ФакторИлиРабота КАК ФакторИлиРабота,
	|	ВложенныйЗапрос.ФакторРабота КАК ФакторРабота
	|ПОМЕСТИТЬ ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Период КАК Период,
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Организация КАК Организация,
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Подразделение КАК Подразделение,
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.МоментВремени КАК МоментВремени,
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Должность КАК Должность,
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.РабочееМесто КАК РабочееМесто,
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.ФакторИлиРабота КАК ФакторИлиРабота,
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.ФакторРабота КАК ФакторРабота
	|	ИЗ
	|		ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах КАК ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах КАК ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах
	|		ПО ВложенныйЗапрос.Организация = ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Организация
	|			И ВложенныйЗапрос.МоментВремени < ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.МоментВремени
	|			И ВложенныйЗапрос.Подразделение = ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Подразделение
	|			И ВложенныйЗапрос.Должность = ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.Должность
	|			И ВложенныйЗапрос.РабочееМесто = ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.РабочееМесто
	|			И ВложенныйЗапрос.ФакторИлиРабота = ВТ_ВредныеИОпасныеФакторыИРаботыНаРабочихМестах.ФакторИлиРабота
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Организация,
	|	ВложенныйЗапрос.Подразделение,
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.Должность,
	|	ВложенныйЗапрос.РабочееМесто,
	|	ВложенныйЗапрос.ФакторИлиРабота,
	|	ВложенныйЗапрос.ФакторРабота
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Работники.Ссылка КАК Ссылка,
	|	Работники.Сотрудник КАК Сотрудник,
	|	Работники.Сотрудник.ФизическоеЛицо.ДатаРождения КАК ДатаРождения,
	|	Работники.Ссылка.Организация КАК Организация,
	|	Работники.Ссылка.Организация.ОГРН КАК ОрганизацияОГРН,
	|	Работники.Ссылка.МедицинскаяОрганизация КАК МедицинскаяОрганизация,
	|	Работники.Ссылка.МедицинскаяОрганизация.ОГРН КАК МедицинскаяОрганизацияОГРН,
	|	Работники.Ссылка.ВидМедосмотра КАК ВидМедосмотра,
	|	ВТ_ПериодыРаботыСотрудников.Подразделение КАК Подразделение,
	|	ВТ_ПериодыРаботыСотрудников.Должность КАК Должность,
	|	ВТ_ПериодыРаботыСотрудников.РабочееМесто КАК РабочееМесто
	|ПОМЕСТИТЬ ВТ_Результат_Предварительный
	|ИЗ
	|	Документ.НаправлениеНаМедицинскийОсмотр.Работники КАК Работники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПериодыРаботыСотрудников КАК ВТ_ПериодыРаботыСотрудников
	|		ПО Работники.Сотрудник = ВТ_ПериодыРаботыСотрудников.Сотрудник
	|			И Работники.Ссылка.Дата <= ВТ_ПериодыРаботыСотрудников.КонецПериода
	|			И Работники.Ссылка.Дата > ВТ_ПериодыРаботыСотрудников.НачалоПериода
	|ГДЕ
	|	Работники.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Результат.Ссылка КАК Ссылка,
	|	ВТ_Результат.Сотрудник КАК Сотрудник,
	|	ВТ_Результат.ДатаРождения КАК ДатаРождения,
	|	ВТ_Результат.Организация КАК Организация,
	|	ВТ_Результат.ОрганизацияОГРН КАК ОрганизацияОГРН,
	|	ВТ_Результат.МедицинскаяОрганизация КАК МедицинскаяОрганизация,
	|	ВТ_Результат.ВидМедосмотра КАК ВидМедосмотра,
	|	ВТ_Результат.Подразделение КАК Подразделение,
	|	ВТ_Результат.Должность КАК Должность,
	|	ВТ_Результат.МедицинскаяОрганизацияОГРН КАК МедицинскаяОрганизацияОГРН,
	|	ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.ФакторИлиРабота КАК ФакторИлиРабота,
	|	ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.ФакторРабота КАК ФакторРабота
	|ПОМЕСТИТЬ ВТ_Результат
	|ИЗ
	|	ВТ_Результат_Предварительный КАК ВТ_Результат
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах КАК ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах
	|		ПО ВТ_Результат.Организация = ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.Организация
	|			И (ВТ_Результат.Подразделение = ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.Подразделение
	|				ИЛИ ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка))
	|			И (ВТ_Результат.Должность = ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.Должность
	|				ИЛИ ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.Должность = ЗНАЧЕНИЕ(Справочник.ДолжностиИпрофессии.ПустаяСсылка))
	|			И (ВТ_Результат.РабочееМесто = ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.РабочееМесто
	|				ИЛИ ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.РабочееМесто = ЗНАЧЕНИЕ(Справочник.РабочиеМестаАСТБ.ПустаяСсылка))
	|			И ВТ_Результат.Ссылка.Дата <= ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.КонецПериода
	|			И ВТ_Результат.Ссылка.Дата > ВТ_ПериодыВредныхИОпасныхФакторовИРаботНаРабочихМестах.НачалоПериода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Результат.Ссылка КАК Ссылка,
	|	ВТ_Результат.Сотрудник КАК Сотрудник,
	|	ВТ_Результат.ДатаРождения КАК ДатаРождения,
	|	ВТ_Результат.Организация КАК Организация,
	|	ВТ_Результат.ОрганизацияОГРН КАК ОрганизацияОГРН,
	|	ВТ_Результат.МедицинскаяОрганизация КАК МедицинскаяОрганизация,
	|	ВТ_Результат.ВидМедосмотра КАК ВидМедосмотра,
	|	ВТ_Результат.Подразделение КАК Подразделение,
	|	ВТ_Результат.Должность КАК Должность,
	|	ВТ_Результат.МедицинскаяОрганизацияОГРН КАК МедицинскаяОрганизацияОГРН
	|ИЗ
	|	ВТ_Результат КАК ВТ_Результат
	|ИТОГИ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Результат.Ссылка КАК Ссылка,
	|	ВТ_Результат.Сотрудник КАК Сотрудник,
	|	ВТ_Результат.ФакторИлиРабота КАК ФакторИлиРабота,
	|	ВТ_Результат.ФакторРабота КАК ФакторРабота
	|ИЗ
	|	ВТ_Результат КАК ВТ_Результат");
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("Период", 		ТекущаяДата());
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.НаправлениеНаМедицинскийОсмотр.ПФ_MXL_НаправлениеНаМедицинскийОсмотр");
	
	Результат = Запрос.ВыполнитьПакет();
	
	ВыборкаПоДокументам = Результат[6].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТаблицаВредности 	= Результат[7].Выгрузить();
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		ВыборкаПоСотрудникам = ВыборкаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоСотрудникам.Следующий() Цикл
			
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ПервыйДокумент = Ложь;
			
			Область = Макет.ПолучитьОбласть("Шапка");
			
			Область.Параметры.АдресОрганизации 	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ВыборкаПоСотрудникам.Организация,Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
			Область.Параметры.ВидМедосмотра 	= ВРег(Строка(ВыборкаПоСотрудникам.ВидМедосмотра));
			
			//ОГРН организации
			Область.Параметры.Заполнить(ПолучитьСтруктуруОГРН(ВыборкаПоСотрудникам.ОрганизацияОГРН));
			
			//представление организации
			ПредставлениеОрганизации = ВыборкаПоСотрудникам.Организация.Наименование;
			Если НЕ ВыборкаПоСотрудникам.Организация.ВидыДеятельности.Количество() = 0 Тогда
			    ПредставлениеОрганизации = ПредставлениеОрганизации + "; " + ВыборкаПоСотрудникам.Организация.ВидыДеятельности[0].ВидДеятельности.Наименование;
			КонецЕсли;	
			Область.Параметры.ПредставлениеОрганизации = ПредставлениеОрганизации;
			
			//представление мед. организации
			ПредставлениеМедицинскойОрганизации = ВыборкаПоСотрудникам.МедицинскаяОрганизация.Наименование;
			АдресМедицинскойОрганизации 		= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(ВыборкаПоСотрудникам.МедицинскаяОрганизация,Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
			Если ЗначениеЗаполнено(АдресМедицинскойОрганизации) Тогда
				ПредставлениеМедицинскойОрганизации = ПредставлениеМедицинскойОрганизации + "; " + АдресМедицинскойОрганизации;
			КонецЕсли;
			Если ЗначениеЗаполнено(ВыборкаПоСотрудникам.МедицинскаяОрганизацияОГРН) Тогда
				ПредставлениеМедицинскойОрганизации = ПредставлениеМедицинскойОрганизации + "; ОГРН: " + ВыборкаПоСотрудникам.МедицинскаяОрганизацияОГРН;
			КонецЕсли;
			Область.Параметры.ПредставлениеМедицинскойОрганизации = ПредставлениеМедицинскойОрганизации;
			
			//данные по сотруднику
			Область.Параметры.ПредставлениеСотрудника 		= ВыборкаПоСотрудникам.Сотрудник.Наименование;
			Область.Параметры.ДатаРождения 					= Формат(ВыборкаПоСотрудникам.ДатаРождения,"ДЛФ=DD");
			Область.Параметры.ПредставлениеПодразделения 	= ВыборкаПоСотрудникам.Подразделение.Наименование;
			Область.Параметры.ПредставлениеДолжности 		= ВыборкаПоСотрудникам.Должность.Наименование;
			
			ХимическиеФакторы 		= "";
			ФизическиеФакторы 		= "";
			БиологическиеФакторы 	= "";
			ТяжестьТруда 			= "";
			ВреднаяРабота 			= "";
			
			НайденныеСтроки = ТаблицаВредности.НайтиСтроки(Новый Структура("Ссылка, Сотрудник", ВыборкаПоСотрудникам.Ссылка, ВыборкаПоСотрудникам.Сотрудник));
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				
				Если НЕ ЗначениеЗаполнено(НайденнаяСтрока.ФакторРабота) Тогда
					Продолжить;
				КонецЕсли;	
				
				Если НайденнаяСтрока.ФакторИлиРабота = "Р" Тогда
					
					Если ВреднаяРабота = "" Тогда
						ВреднаяРабота = НайденнаяСтрока.ФакторРабота.Код;
					Иначе
						ВреднаяРабота = ВреднаяРабота + " / " + НайденнаяСтрока.ФакторРабота.Код;
					КонецЕсли;
					
				Иначе
					
					Если Лев(НайденнаяСтрока.ФакторРабота.Код,2) = "1." ТОгда //химический фактор
						
						Если ХимическиеФакторы = "" Тогда
							ХимическиеФакторы = НайденнаяСтрока.ФакторРабота.Код;
						Иначе
							ХимическиеФакторы = ХимическиеФакторы + " / " + НайденнаяСтрока.ФакторРабота.Код;
						КонецЕсли;	
						
					ИначеЕсли Лев(НайденнаяСтрока.ФакторРабота.Код,2) = "2." ТОгда //биологический фактор
						
						Если БиологическиеФакторы = "" Тогда
							БиологическиеФакторы = НайденнаяСтрока.ФакторРабота.Код;
						Иначе
							БиологическиеФакторы = БиологическиеФакторы + " / " + НайденнаяСтрока.ФакторРабота.Код;
						КонецЕсли;
						
					ИначеЕсли Лев(НайденнаяСтрока.ФакторРабота.Код,2) = "3." ТОгда //физический фактор
						
						Если ФизическиеФакторы = "" Тогда
							ФизическиеФакторы = НайденнаяСтрока.ФакторРабота.Код;
						Иначе
							ФизическиеФакторы = ФизическиеФакторы + " / " + НайденнаяСтрока.ФакторРабота.Код;
						КонецЕсли;	
						
					ИначеЕсли Лев(НайденнаяСтрока.ФакторРабота.Код,2) = "4." ТОгда //трудовой фактор
						
						Если ТяжестьТруда = "" Тогда
							ТяжестьТруда = НайденнаяСтрока.ФакторРабота.Код;
						Иначе
							ТяжестьТруда = ТяжестьТруда + " / " + НайденнаяСтрока.ФакторРабота.Код;
						КонецЕсли;	
						
					КонецЕсли;	
					
				КонецЕсли;	
				
			КонецЦикла;	
			
			//вредность
			Область.Параметры.ХимическиеФакторы 	= ХимическиеФакторы;
			Область.Параметры.ФизическиеФакторы 	= ФизическиеФакторы;
			Область.Параметры.БиологическиеФакторы 	= БиологическиеФакторы;
			Область.Параметры.ТяжестьТруда 			= ТяжестьТруда;
			Область.Параметры.ВреднаяРабота 		= ВреднаяРабота;
			
			ТабличныйДокумент.Вывести(Область);
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоСотрудникам.Ссылка);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьСтруктуруОГРН(ОГРН)
	
	СтруктураОГРН = Новый Структура;
	
	Для Сч=1 По 13 Цикл
		
		СтруктураОГРН.Вставить("ОГРН" + Сч,Сред(ОГРН,Сч,1));
		
	КонецЦикла;
	
	Возврат СтруктураОГРН;
	
КонецФункции	

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//направление
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.НаправлениеНаМедицинскийОсмотр";
	КомандаПечати.Идентификатор = "Направление";
	КомандаПечати.Представление = НСтр("ru = 'Направление на медицинский осмотр'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

#КонецЕсли