
Функция ОтправитьПакетОбмена(ПакетОбмена)
	
	СтруктураОтвета = Новый Структура("ЕстьОшибки,ОписаниеОшибки",Ложь);
	
	Попытка
		
		АХ_ОбменПравилаЗагрузки.ОбработатьПринятыйПакетОбмена(ПакетОбмена);
		
	Исключение	
		
		Если ТранзакцияАктивна() Тогда 
			ОтменитьТранзакцию();
		КонецЕсли;
		
		Инфо = ИнформацияОбОшибке();		
		
		СтруктураОтвета.ЕстьОшибки = Истина;		
		СтруктураОтвета.ОписаниеОшибки = Инфо.Описание;
		
		//регистрируем ошибку в журнале
		ЗаписьЖурналаРегистрации(нСтр("ru='Ошибка принятия пакета обмена по веб сервису EisfExchange '", "ru"),
		УровеньЖурналаРегистрации.Ошибка,
		Метаданные.WebСервисы.AdressStorageExchange,
		,
		ПодробноеПредставлениеОшибки(Инфо));
		
	КонецПопытки;
	
	Возврат Новый ХранилищеЗначения(СтруктураОтвета);
	
	
КонецФункции

Функция Ping()
	Возврат "";	
КонецФункции

Функция НачатьПредварительнуюСборку(Период)
	
	СтруктураОтвета = Новый Структура("Результат,СообщениеОбОшибке,Штрихкод",Истина,"","");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВыдачаСредствЗащитыСотруднику.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ВыдачаСредствЗащитыСотруднику КАК ВыдачаСредствЗащитыСотруднику
	|ГДЕ
	|	ВыдачаСредствЗащитыСотруднику.Проведен
	|	И ВыдачаСредствЗащитыСотруднику.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ВыдачаСредствЗащитыСотруднику.ВидВыдачиСИЗ = ЗНАЧЕНИЕ(Перечисление.ВидывыдачиСИЗ.ПерсональнаяВыдача)
	|	И ВыдачаСредствЗащитыСотруднику.АХ_СтатусСборки = ЗНАЧЕНИЕ(Перечисление.АХ_статусыСборкиТоваров.ПредварительнаяСборка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВыдачаСредствЗащитыСотруднику.МоментВремени";
	
	Запрос.УстановитьПараметр("ДатаНачала",    НачалоДня(Период));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Период));
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда 
		
		СтруктураОтвета.Результат = Ложь;
		СтруктураОтвета.СообщениеОбОшибке = "Нет документов к предварительной сборке";
		
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();		
		
		Попытка
			
			НачатьТранзакцию();
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			Попытка
				
				ОбъектДокумента.Заблокировать();
				
			Исключение
				
				СтруктураОтвета.Результат = Ложь;
				СтруктураОтвета.СообщениеОбОшибке = "Документ: " + Выборка.Ссылка + " заблокирован пользователем. Обратитесь к оператору.";
				Возврат Новый ХранилищеЗначения(СтруктураОтвета);	
				
			КонецПопытки;
			
			ОбъектДокумента.АХ_СтатусСборки = Перечисления.АХ_СтатусыСборкиТоваров.Подготовлено;
			ОбъектДокумента.Записать(РежимЗаписиДокумента.Проведение);
			
			СтруктураОбработкиОшибок = АХ_ОбменВызовСервера.ИнициализироватьСтруктуруОбработкиОшибок();
			
			Соответствие = Новый Соответствие;	
			Соответствие.Вставить("ПланСнятия",Выборка.Ссылка);
			
			МассивДанных = Новый Массив;
			МассивДанных.Добавить(Соответствие);
			
			АХ_ОбменВызовСервера.ПередатьДанныеВАдресноеХранение(МассивДанных,СтруктураОбработкиОшибок);	
			
			Если СтруктураОбработкиОшибок.ЕстьОшибки Тогда
				
				СтруктураОтвета.Результат = Ложь;
				СтруктураОтвета.СообщениеОбОшибке = "По документу: " + Выборка.Ссылка + " обнаружены ошибки. Обратитесь к оператору.";
				
				ОтменитьТранзакцию();
				
			иначе
				
				//на данном этапе, план снятия создался, и все ок
				//в случае если не удается получить штрихкод по плану снятия.
				
				ЗафиксироватьТранзакцию();
				
				ГУИД = Строка(Выборка.Ссылка.УникальныйИдентификатор());
				
				Прокси = АХ_ОбменВызовСервера.ПолучитьПрокси(СтруктураОбработкиОшибок);
				Если Прокси <> Неопределено Тогда 
					
					АХ_СтруктураОтвета = Прокси.ШтрихкодПланаСнятияПоУправленческомуДокументу(ГУИД);
					АХ_СтруктураОтвета = СериализаторXDTO.ПрочитатьXDTO(АХ_СтруктураОтвета);
					
					Если АХ_СтруктураОтвета.Результат = Ложь Тогда
						
						СтруктураОтвета.Результат = АХ_СтруктураОтвета.Результат;
						СтруктураОтвета.СообщениеОбОшибке = АХ_СтруктураОтвета.СообщениеОбОшибке;
						
					Иначе
						
						СтруктураОтвета.Результат = Истина;
						СтруктураОтвета.Штрихкод = АХ_СтруктураОтвета.Штрихкод;
						
					КонецЕсли;
					
				Иначе
					
					СтруктураОтвета.Результат = Ложь;
					СтруктураОтвета.СообщениеОбОшибке = "Не удалось получить штрихкод плана снятия по документу:" + Выборка.Ссылка + ". Распечатайте план снятия и отсканируйте штрихкод";
					
				КонецЕсли;
				
			КонецЕсли;
			
		Исключение
			
			Если ТранзакцияАктивна() Тогда 
				ОтменитьТранзакцию();
			КонецЕсли;
			
			СтруктураОтвета.Результат = Ложь;
			СтруктураОтвета.СообщениеОбОшибке = ОписаниеОшибки();
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Новый ХранилищеЗначения(СтруктураОтвета);
	
КонецФункции

Функция ТаблицаСотрудниковПоШтрихкодам(МассивШтрихкодов)
	
	МассивШтрихкодов = МассивШтрихкодов.Получить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШтрихкодыНоменклатурыДляУчетаЧистки.Штрихкод КАК Штрихкод,
		|	ШтрихкодыНоменклатурыДляУчетаЧистки.Сотрудник.Наименование КАК ФИО,
		|	ШтрихкодыНоменклатурыДляУчетаЧистки.Сотрудник КАК Сотрудник,
		|	ШтрихкодыНоменклатурыДляУчетаЧистки.Номенклатура КАК Номенклатура,
		|	ШтрихкодыНоменклатурыДляУчетаЧистки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
		|ИЗ
		|	РегистрСведений.ШтрихкодыНоменклатурыДляУчетаЧистки КАК ШтрихкодыНоменклатурыДляУчетаЧистки
		|ГДЕ
		|	ШтрихкодыНоменклатурыДляУчетаЧистки.Штрихкод В(&МассивШтрихкодов)";
	
	Запрос.УстановитьПараметр("МассивШтрихкодов", МассивШтрихкодов);
	
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(200));
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	ТаблицаРезультат.Колонки.Добавить("Штрихкод",				   ОписаниеТиповСтрока);
	ТаблицаРезультат.Колонки.Добавить("ФИО",				       ОписаниеТиповСтрока);
	ТаблицаРезультат.Колонки.Добавить("Сотрудник",			       ОписаниеТиповСтрока);
	ТаблицаРезультат.Колонки.Добавить("Номенклатура",			   ОписаниеТиповСтрока);
	ТаблицаРезультат.Колонки.Добавить("ХарактеристикаНоменклатуры",ОписаниеТиповСтрока);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаТаблицы = ТаблицаРезультат.Добавить();
		
		НоваяСтрокаТаблицы.Штрихкод 				  = Выборка.Штрихкод;
		НоваяСтрокаТаблицы.ФИО 						  = Выборка.ФИО;
		НоваяСтрокаТаблицы.Сотрудник				  = ?(ЗначениеЗаполнено(Выборка.Сотрудник),Строка(Выборка.Сотрудник.УникальныйИдентификатор()),"");
		НоваяСтрокаТаблицы.Номенклатура 			  = ?(ЗначениеЗаполнено(Выборка.Номенклатура),Строка(Выборка.Номенклатура.УникальныйИдентификатор()),"");
		НоваяСтрокаТаблицы.ХарактеристикаНоменклатуры = ?(ЗначениеЗаполнено(Выборка.ХарактеристикаНоменклатуры),Строка(Выборка.ХарактеристикаНоменклатуры.УникальныйИдентификатор()),"");
		
	КонецЦикла;
	
	Возврат Новый ХранилищеЗначения(ТаблицаРезультат);
	
КонецФункции
