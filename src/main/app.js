// Initial Data setup for local storage
const initialData = {
    users: [
        { id: 1, name: 'John Doe', email: 'john@example.com', phone: '555-0101', status: 'Active' },
        { id: 2, name: 'Jane Smith', email: 'jane@example.com', phone: '555-0102', status: 'Inactive' }
    ],
    vehicles: [
        { id: 1, make: 'Toyota', model: 'Camry', year: 2020, regNumber: 'ABC-1234', owner: 'John Doe' },
        { id: 2, make: 'Honda', model: 'Civic', year: 2021, regNumber: 'XYZ-9876', owner: 'Jane Smith' }
    ],
    bookings: [
        { id: 1, customer: 'John Doe', vehicle: 'Toyota Camry', date: '2026-05-10', serviceType: 'Full Service', status: 'Pending' },
        { id: 2, customer: 'Jane Smith', vehicle: 'Honda Civic', date: '2026-05-12', serviceType: 'Oil Change', status: 'Confirmed' }
    ],
    payments: [
        { id: 1, bookingId: 'BK-001', amount: 150, method: 'Credit Card', date: '2026-05-10', status: 'Paid' },
        { id: 2, bookingId: 'BK-002', amount: 45, method: 'Cash', date: '2026-05-12', status: 'Pending' }
    ],
    admins: [
        { id: 1, name: 'Admin User', role: 'Super Admin', email: 'admin@drivesync.com', status: 'Active' },
        { id: 2, name: 'Support Staff', role: 'Support', email: 'support@drivesync.com', status: 'Active' }
    ],
    feedbacks: [
        { id: 1, customer: 'John Doe', rating: 5, comment: 'Great service, highly recommend!', date: '2026-04-28' },
        { id: 2, customer: 'Jane Smith', rating: 4, comment: 'Good, but took a bit longer than expected.', date: '2026-04-29' }
    ]
};

// Initialize LocalStorage if empty
if (!localStorage.getItem('driveSyncData')) {
    localStorage.setItem('driveSyncData', JSON.stringify(initialData));
}

// Global State
let currentSection = 'users';
let editingId = null;

// Configurations for each module
const sectionConfig = {
    users: {
        title: 'User Management',
        columns: ['Name', 'Email', 'Phone', 'Status'],
        keys: ['name', 'email', 'phone', 'status'],
        form: [
            { name: 'name', label: 'Full Name', type: 'text', required: true },
            { name: 'email', label: 'Email Address', type: 'email', required: true },
            { name: 'phone', label: 'Phone Number', type: 'text', required: true },
            { name: 'status', label: 'Status', type: 'select', options: ['Active', 'Inactive'] }
        ]
    },
    vehicles: {
        title: 'Vehicle Management',
        columns: ['Make', 'Model', 'Year', 'Reg. Number', 'Owner'],
        keys: ['make', 'model', 'year', 'regNumber', 'owner'],
        form: [
            { name: 'make', label: 'Make', type: 'text', required: true },
            { name: 'model', label: 'Model', type: 'text', required: true },
            { name: 'year', label: 'Year', type: 'number', required: true },
            { name: 'regNumber', label: 'Registration Number', type: 'text', required: true },
            { name: 'owner', label: 'Owner Name', type: 'text', required: true }
        ]
    },
    bookings: {
        title: 'Booking Management',
        columns: ['Customer', 'Vehicle', 'Date', 'Service Type', 'Status'],
        keys: ['customer', 'vehicle', 'date', 'serviceType', 'status'],
        form: [
            { name: 'customer', label: 'Customer Name', type: 'text', required: true },
            { name: 'vehicle', label: 'Vehicle Details', type: 'text', required: true },
            { name: 'date', label: 'Service Date', type: 'date', required: true },
            { name: 'serviceType', label: 'Service Type', type: 'select', options: ['Full Service', 'Oil Change', 'Repair', 'Inspection'] },
            { name: 'status', label: 'Status', type: 'select', options: ['Pending', 'Confirmed', 'Completed', 'Cancelled'] }
        ]
    },
    payments: {
        title: 'Payment Management',
        columns: ['Booking ID', 'Amount ($)', 'Method', 'Date', 'Status'],
        keys: ['bookingId', 'amount', 'method', 'date', 'status'],
        form: [
            { name: 'bookingId', label: 'Booking Reference', type: 'text', required: true },
            { name: 'amount', label: 'Amount', type: 'number', required: true },
            { name: 'method', label: 'Payment Method', type: 'select', options: ['Credit Card', 'Cash', 'Bank Transfer', 'Online'] },
            { name: 'date', label: 'Payment Date', type: 'date', required: true },
            { name: 'status', label: 'Status', type: 'select', options: ['Paid', 'Pending', 'Failed', 'Refunded'] }
        ]
    },
    admins: {
        title: 'Admin Management',
        columns: ['Name', 'Role', 'Email', 'Status'],
        keys: ['name', 'role', 'email', 'status'],
        form: [
            { name: 'name', label: 'Admin Name', type: 'text', required: true },
            { name: 'email', label: 'Email Address', type: 'email', required: true },
            { name: 'role', label: 'Role', type: 'select', options: ['Super Admin', 'Manager', 'Support'] },
            { name: 'status', label: 'Status', type: 'select', options: ['Active', 'Inactive'] }
        ]
    },
    feedbacks: {
        title: 'Feedback & Review Management',
        columns: ['Customer', 'Rating', 'Comment', 'Date'],
        keys: ['customer', 'rating', 'comment', 'date'],
        form: [
            { name: 'customer', label: 'Customer Name', type: 'text', required: true },
            { name: 'rating', label: 'Rating (1-5)', type: 'number', required: true },
            { name: 'comment', label: 'Comment', type: 'text', required: true },
            { name: 'date', label: 'Date', type: 'date', required: true }
        ]
    }
};

// DOM Elements
const sidebarNav = document.getElementById('sidebar-nav');
const headerTitle = document.getElementById('header-title');
const tableHead = document.getElementById('table-head');
const tableBody = document.getElementById('table-body');
const emptyState = document.getElementById('empty-state');
const dataTable = document.getElementById('data-table');
const searchInput = document.getElementById('search-input');

// Modal Elements
const crudModal = document.getElementById('crud-modal');
const modalTitle = document.getElementById('modal-title');
const formFieldsContainer = document.getElementById('form-fields-container');
const crudForm = document.getElementById('crud-form');
const btnAddNew = document.getElementById('btn-add-new');
const btnCloseModal = document.getElementById('btn-close-modal');
const btnCancelModal = document.getElementById('btn-cancel-modal');

// Utility Functions
const getData = () => JSON.parse(localStorage.getItem('driveSyncData'));
const saveData = (data) => localStorage.setItem('driveSyncData', JSON.stringify(data));

const renderBadge = (value) => {
    const v = value.toString().toLowerCase();
    if (['active', 'paid', 'completed', 'confirmed'].includes(v)) return `<span class="badge badge-success">${value}</span>`;
    if (['pending'].includes(v)) return `<span class="badge badge-warning">${value}</span>`;
    if (['inactive', 'failed', 'cancelled'].includes(v)) return `<span class="badge badge-danger">${value}</span>`;
    return value;
};

// Rendering Table
const renderTable = (searchTerm = '') => {
    const config = sectionConfig[currentSection];
    const data = getData()[currentSection];

    // Update Header
    headerTitle.textContent = config.title;

    // Render TH
    tableHead.innerHTML = `<tr>
        ${config.columns.map(col => `<th>${col}</th>`).join('')}
        <th style="width: 100px; text-align: right;">Actions</th>
    </tr>`;

    // Filter Data
    const filteredData = data.filter(item => {
        if (!searchTerm) return true;
        return Object.values(item).some(val =>
            val.toString().toLowerCase().includes(searchTerm.toLowerCase())
        );
    });

    // Render TBODY
    if (filteredData.length === 0) {
        dataTable.style.display = 'none';
        emptyState.style.display = 'flex';
    } else {
        dataTable.style.display = 'table';
        emptyState.style.display = 'none';

        tableBody.innerHTML = filteredData.map(item => `
            <tr>
                ${config.keys.map(key => `<td>${key === 'status' || key === 'rating' ? renderBadge(item[key]) : item[key]}</td>`).join('')}
                <td>
                    <div class="action-btns">
                        <button class="icon-btn btn-edit-text" onclick="editRecord(${item.id})"><i class="ph ph-pencil-simple"></i></button>
                        <button class="icon-btn btn-danger-text" onclick="deleteRecord(${item.id})"><i class="ph ph-trash"></i></button>
                    </div>
                </td>
            </tr>
        `).join('');
    }
};

// Form Generation
const generateForm = (record = null) => {
    const config = sectionConfig[currentSection];
    modalTitle.textContent = record ? `Edit ${config.title.split(' ')[0]}` : `Add New ${config.title.split(' ')[0]}`;
    editingId = record ? record.id : null;

    formFieldsContainer.innerHTML = config.form.map(field => {
        const value = record ? record[field.name] : '';
        let inputHtml = '';

        if (field.type === 'select') {
            inputHtml = `
                <select class="form-control" id="${field.name}" name="${field.name}" ${field.required ? 'required' : ''}>
                    ${field.options.map(opt => `<option value="${opt}" ${value === opt ? 'selected' : ''}>${opt}</option>`).join('')}
                </select>
            `;
        } else {
            inputHtml = `<input type="${field.type}" class="form-control" id="${field.name}" name="${field.name}" value="${value}" ${field.required ? 'required' : ''}>`;
        }

        return `
            <div class="form-group">
                <label for="${field.name}">${field.label}</label>
                ${inputHtml}
            </div>
        `;
    }).join('');
};

// Modal Actions
const openModal = () => crudModal.classList.add('active');
const closeModal = () => {
    crudModal.classList.remove('active');
    crudForm.reset();
};

// CRUD Operations
window.editRecord = (id) => {
    const data = getData()[currentSection];
    const record = data.find(item => item.id === id);
    if (record) {
        generateForm(record);
        openModal();
    }
};

window.deleteRecord = (id) => {
    if (confirm('Are you sure you want to delete this record?')) {
        const allData = getData();
        allData[currentSection] = allData[currentSection].filter(item => item.id !== id);
        saveData(allData);
        renderTable(searchInput.value);
    }
};

crudForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const config = sectionConfig[currentSection];
    const formData = new FormData(crudForm);
    const newRecord = {};

    config.form.forEach(field => {
        newRecord[field.name] = formData.get(field.name);
    });

    const allData = getData();

    if (editingId) {
        // Update
        const index = allData[currentSection].findIndex(item => item.id === editingId);
        if (index !== -1) {
            allData[currentSection][index] = { ...allData[currentSection][index], ...newRecord };
        }
    } else {
        // Create
        const maxId = allData[currentSection].reduce((max, item) => Math.max(max, item.id), 0);
        newRecord.id = maxId + 1;
        allData[currentSection].unshift(newRecord); // Add to top
    }

    saveData(allData);
    closeModal();
    renderTable(searchInput.value);
});

// Event Listeners
sidebarNav.addEventListener('click', (e) => {
    const navItem = e.target.closest('.nav-item');
    if (navItem) {
        e.preventDefault();

        // Update active class
        document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
        navItem.classList.add('active');

        // Update section
        currentSection = navItem.dataset.target;
        searchInput.value = '';
        renderTable();
    }
});

btnAddNew.addEventListener('click', () => {
    generateForm();
    openModal();
});

btnCloseModal.addEventListener('click', closeModal);
btnCancelModal.addEventListener('click', closeModal);

searchInput.addEventListener('input', (e) => {
    renderTable(e.target.value);
});

// Close modal on outside click
crudModal.addEventListener('click', (e) => {
    if (e.target === crudModal) {
        closeModal();
    }
});

// Initial Render
renderTable();
